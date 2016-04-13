package LBNLActors.util;

import java.io.File;
import java.io.FileWriter;
import java.io.PrintWriter;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.lang.ProcessBuilder;
import java.util.List;
import java.util.ArrayList;

import ptolemy.kernel.util.IllegalActionException;

public class ClientProcess extends Thread {
    //public class ClientProcess {

    private final static String LS = System.getProperty("line.separator");
   
    /** Constructor */
    public ClientProcess(){
      super();
      proSta = false;
      errMes = null;
    }

    /** Sets the simulation log file */
    public void setSimulationLogFile(File simLogFil){
	logFil = new File(simLogFil.getAbsolutePath());
	logToSysOut = true;
	// Delete log file if it exists
	logFil.delete();
    }

    /** Runs the process. */
    public void run() {
	ProcessBuilder pb = new ProcessBuilder(cmdArr);
	try{
	    proSta = false;
	    pb.directory(worDir);
	    pb.redirectErrorStream(true);
	    simPro = pb.start();
	    proSta = true;
	    new PrintOutput().start();
	}
	catch (SecurityException exc){
	    proSta = false;
	    errMes = "Error when starting external process." + LS
		+ "You may not have the permission to execute this command." + LS
                + "Error message           : " + exc.getMessage() + LS
		+ "Current directory       : " + worDir + LS
		+ "ProcessBuilder arguments: " + pb.command().toString();
	}
	catch (java.io.IOException exc){
	    proSta = false;
	    errMes = "Error when starting external process." + LS
                + "Error message           : " + exc.getMessage() + LS
		+ "Current directory       : " + worDir + LS
		+ "ProcessBuilder arguments: " + pb.command().toString();
	}
    }
    
    /** Returns <code>true</code> if the process started without throwing an exception */
    public boolean processStarted(){
        return proSta;
    }
    
    /** Returns the error message if <code>proSta=true</code> or a null pointer otherwise
     * @return the error message if <code>proSta=true</code> or a null pointer otherwise
     */
    public String getErrorMessage(){
	return errMes;
    }

    
    /** Inner class to print any output of the process to the console */
    private class PrintOutput 
	extends Thread
    {
	public PrintOutput() {}

	/** Runs the process. */
	public void run() {
	    if (simPro == null) 
		return;
	    InputStream is = simPro.getInputStream();
	    InputStreamReader isr = new InputStreamReader(is);
	    BufferedReader br = new BufferedReader(isr);
	    PrintWriter pwLogFil;
	    PrintWriter pwSysOut = new PrintWriter(System.out);
	    try{
		 pwLogFil = new PrintWriter(new BufferedWriter(new FileWriter(logFil)));
	    }
	    catch(java.io.IOException e){
		e.printStackTrace();
		pwLogFil = new PrintWriter(System.err);
	    }
	    
	    String line;
	    try{
		while ((line = br.readLine()) != null) {
		    if (logToSysOut){
			pwSysOut.println(line);
			pwSysOut.flush();
		    }
		    pwLogFil.println(line);
		    pwLogFil.flush();
		}
	    }
	    catch(java.io.IOException e){
		e.printStackTrace();
	    }
	}	
    }

    /** Set the process arguments.
     *@param cmdarray array containing the command to call and its arguments.
     *@param dir the working directory of the subprocess.
     *@exception IllegalActionException if the canonical path name of the program file
     *                                  cannot be obtained.
     */
    public void setProcessArguments(List<String> cmdarray,
				    String dir)
	throws IllegalActionException{
	cmdArr = new ArrayList<String>();
	for (int i=0; i < cmdarray.size(); i++){
	    if ( i == 0 ){
		// The first item is the command. If it points to a file
		// then we get the absolute file name. Otherwise, invoking a command
		// like ../cclient will not work.
		String s = cmdarray.get(i);
		File f = new File(s);
		if (f.exists()){
		    try{
			s = f.getCanonicalPath();
		    }
		    catch(java.io.IOException exc){
			String em = "Error: Could not get canonical path for '" + s + "'.";
			throw new IllegalActionException(em);
		    }
		}
		cmdArr.add(s);
	    }
	    else
		cmdArr.add(cmdarray.get(i));
	}

	if (dir.equalsIgnoreCase(".")) 
	    worDir = new File(System.getProperty("user.dir"));
	else if (dir.startsWith("./"))
	    worDir = new File(System.getProperty("user.dir") + dir.substring(1));
	else{
	    worDir = new File(dir);
	    if ( !worDir.isAbsolute() )
		worDir = new File(System.getProperty("user.dir") + File.separator + dir);
	}
    }
    
    /** Array containing the command to call and its arguments */
    List<String> cmdArr;

    /** Working directory of the subprocess, or null if the subprocess should inherit the working directory of the current process */
    File worDir;

    /** Log file where simulation output will be written to */
    File logFil;

    /** Flag, if <code>true</code>, then the output will be written to System.out */
    boolean logToSysOut;

    /** Process for the simulation */
    Process simPro;

    /** Flag that is set to <code>true</code> if the process started without throwing an exception */
    boolean proSta;

    /** Error message if <code>proSta=true</code> or null pointer otherwise */
    String errMes;

    /** Main method for testing */
    public static void main(String args[]) 
	throws IllegalActionException{
	ClientProcess c = new ClientProcess();
	List<String> com = new ArrayList<String>();
	for (int i = 0; i < args.length; i++)
	    com.add(args[i]);
        c.setProcessArguments(com, ".");
	c.run();
    }
}

/*
********************************************************************
Copyright Notice
----------------

Building Controls Virtual Test Bed (BCVTB) Copyright (c) 2008, The
Regents of the University of California, through Lawrence Berkeley
National Laboratory (subject to receipt of any required approvals from
the U.S. Dept. of Energy). All rights reserved.

If you have questions about your rights to use or distribute this
software, please contact Berkeley Lab's Technology Transfer Department
at TTD@lbl.gov

NOTICE.  This software was developed under partial funding from the U.S.
Department of Energy.  As such, the U.S. Government has been granted for
itself and others acting on its behalf a paid-up, nonexclusive,
irrevocable, worldwide license in the Software to reproduce, prepare
derivative works, and perform publicly and display publicly.  Beginning
five (5) years after the date permission to assert copyright is obtained
from the U.S. Department of Energy, and subject to any subsequent five
(5) year renewals, the U.S. Government is granted for itself and others
acting on its behalf a paid-up, nonexclusive, irrevocable, worldwide
license in the Software to reproduce, prepare derivative works,
distribute copies to the public, perform publicly and display publicly,
and to permit others to do so.


Modified BSD License agreement
------------------------------

Building Controls Virtual Test Bed (BCVTB) Copyright (c) 2008, The
Regents of the University of California, through Lawrence Berkeley
National Laboratory (subject to receipt of any required approvals from
the U.S. Dept. of Energy).  All rights reserved.

Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions are met:

   1. Redistributions of source code must retain the above copyright
      notice, this list of conditions and the following disclaimer.
   2. Redistributions in binary form must reproduce the above copyright
      notice, this list of conditions and the following disclaimer in
      the documentation and/or other materials provided with the
      distribution.
   3. Neither the name of the University of California, Lawrence
      Berkeley National Laboratory, U.S. Dept. of Energy nor the names
      of its contributors may be used to endorse or promote products
      derived from this software without specific prior written permission. 

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS
IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED
TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A
PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER
OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL,
EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO,
PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR
PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF
LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

You are under no obligation whatsoever to provide any bug fixes,
patches, or upgrades to the features, functionality or performance of
the source code ("Enhancements") to anyone; however, if you choose to
make your Enhancements available either publicly, or directly to
Lawrence Berkeley National Laboratory, without imposing a separate
written license agreement for such Enhancements, then you hereby grant
the following license: a non-exclusive, royalty-free perpetual license
to install, use, modify, prepare derivative works, incorporate into
other computer software, distribute, and sublicense such enhancements or
derivative works thereof, in binary and source code form.

********************************************************************
*/