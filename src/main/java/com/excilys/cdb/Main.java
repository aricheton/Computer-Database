package com.excilys.cdb;
import com.excilys.cdb.cli.CommandParser;

public class Main {

	public static void main(String[] args) {
			
		CommandParser cp = new CommandParser();
		cp.welcome();
		while(true){
			cp.displayAvailableCmds();
			cp.parseCmd();
		}
	}

}