package com.excilys.cdb.services;

import java.util.List;

import com.excilys.cdb.dao.impl.ComputerDAOImpl;
import com.excilys.cdb.models.Computer;

public class ComputerService {

	// Singleton
	private static ComputerService instance;
	
	// Constructors
	private ComputerService(){};
	
	// Methods
	public static ComputerService getInstance(){
		if(instance == null){
			instance = new ComputerService();
		}		
		return instance;
	}
	
	public List<Computer> findAll(){
		return ComputerDAOImpl.getInstance().findAll();
	}
	
	public List<Computer> findById(int id){
		return ComputerDAOImpl.getInstance().findById(id);
	}
	
	public List<Computer> findByName(String name){
		return ComputerDAOImpl.getInstance().findByName(name);
	}
	
	public void createComputer(Computer computer){
		validateComputerDates(computer);
		validateComputerName(computer);
		ComputerDAOImpl.getInstance().insertComputer(computer);
	}
	
	public void updateComputer(Computer computer){
		ComputerDAOImpl.getInstance().updateComputer(computer);
	}
	
	public void deleteComputer(int id){
		ComputerDAOImpl.getInstance().deleteComputer(id);
	}	
	
	private void validateComputerDates(Computer computer) throws IllegalArgumentException {
		if(computer.getIntroduced() != null && computer.getDiscontinued() != null){
			if(computer.getIntroduced().isAfter(computer.getDiscontinued())){
				throw new IllegalArgumentException("Computer Introduced localdatetime attribute setted after discontinued localdatetime");
			}
		}
	}
	
	private void validateComputerName(Computer computer) throws IllegalArgumentException {
		if(computer.getName() == null || computer.getName().isEmpty()){
				throw new IllegalArgumentException("Computer name should be not null or empty");
		}
	}
}
