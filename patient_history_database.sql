-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='TRADITIONAL,ALLOW_INVALID_DATES';

-- -----------------------------------------------------
-- Schema patient_history
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema patient_history
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `patient_history` DEFAULT CHARACTER SET utf8 COLLATE utf8_general_ci ;
USE `patient_history` ;

-- -----------------------------------------------------
-- Table `patient_history`.`pharmacy`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `patient_history`.`pharmacy` (
  `pharmacy_id` INT NOT NULL,
  `name` VARCHAR(80) NULL,
  `phone` VARCHAR(20) NULL,
  PRIMARY KEY (`pharmacy_id`))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `patient_history`.`medical_centers`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `patient_history`.`medical_centers` (
  `medical_center_id` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(80) NOT NULL,
  `phone` VARCHAR(20) NULL,
  PRIMARY KEY (`medical_center_id`),
  UNIQUE INDEX `name_UNIQUE` (`name` ASC))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `patient_history`.`physicians`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `patient_history`.`physicians` (
  `physician_id` INT NOT NULL AUTO_INCREMENT,
  `name` VARCHAR(80) NOT NULL,
  `phone` VARCHAR(20) NULL,
  `specialty` VARCHAR(80) NULL,
  PRIMARY KEY (`physician_id`),
  UNIQUE INDEX `name_UNIQUE` (`name` ASC))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `patient_history`.`addresses`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `patient_history`.`addresses` (
  `address_id` INT NOT NULL,
  `address` VARCHAR(80) NULL,
  `medical_center_id` INT NOT NULL,
  `pharmacy_id` INT NOT NULL,
  `physician_id` INT NOT NULL,
  PRIMARY KEY (`address_id`),
  INDEX `fk_addresses_medical_centers1_idx` (`medical_center_id` ASC),
  INDEX `fk_addresses_pharmacy1_idx` (`pharmacy_id` ASC),
  INDEX `fk_addresses_physicians1_idx` (`physician_id` ASC),
  CONSTRAINT `fk_addresses_medical_centers1`
    FOREIGN KEY (`medical_center_id`)
    REFERENCES `patient_history`.`medical_centers` (`medical_center_id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `fk_addresses_pharmacy1`
    FOREIGN KEY (`pharmacy_id`)
    REFERENCES `patient_history`.`pharmacy` (`pharmacy_id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE,
  CONSTRAINT `fk_addresses_physicians1`
    FOREIGN KEY (`physician_id`)
    REFERENCES `patient_history`.`physicians` (`physician_id`)
    ON DELETE CASCADE
    ON UPDATE CASCADE)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `patient_history`.`patients`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `patient_history`.`patients` (
  `patient_id` INT NOT NULL AUTO_INCREMENT,
  `first_name` VARCHAR(80) NOT NULL,
  `middle_name` VARCHAR(45) NULL,
  `last_name` VARCHAR(80) NOT NULL,
  `gender` VARCHAR(10) NULL,
  `date_of_birth` DATE NULL,
  `pharmacy_id` INT NOT NULL,
  `address_id` INT NOT NULL,
  PRIMARY KEY (`patient_id`, `address_id`),
  INDEX `fk_patients_pharmacy1_idx` (`pharmacy_id` ASC),
  INDEX `fk_patients_addresses1_idx` (`address_id` ASC),
  CONSTRAINT `fk_patients_pharmacy1`
    FOREIGN KEY (`pharmacy_id`)
    REFERENCES `patient_history`.`pharmacy` (`pharmacy_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_patients_addresses1`
    FOREIGN KEY (`address_id`)
    REFERENCES `patient_history`.`addresses` (`address_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `patient_history`.`medications`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `patient_history`.`medications` (
  `medication_id` INT NOT NULL AUTO_INCREMENT,
  `quantity` INT NULL,
  `dosage` VARCHAR(45) NULL,
  `name` VARCHAR(100) NOT NULL,
  PRIMARY KEY (`medication_id`),
  UNIQUE INDEX `name_UNIQUE` (`name` ASC))
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `patient_history`.`center_physician`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `patient_history`.`center_physician` (
  `medical_center_id` INT NOT NULL,
  `physician_id` INT NOT NULL,
  PRIMARY KEY (`medical_center_id`, `physician_id`),
  INDEX `fk_medical_centers_has_physicians_physicians1_idx` (`physician_id` ASC),
  INDEX `fk_medical_centers_has_physicians_medical_centers1_idx` (`medical_center_id` ASC),
  CONSTRAINT `fk_medical_centers_has_physicians_medical_centers1`
    FOREIGN KEY (`medical_center_id`)
    REFERENCES `patient_history`.`medical_centers` (`medical_center_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_medical_centers_has_physicians_physicians1`
    FOREIGN KEY (`physician_id`)
    REFERENCES `patient_history`.`physicians` (`physician_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `patient_history`.`patient_medication`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `patient_history`.`patient_medication` (
  `patient_id` INT NOT NULL,
  `medication_id` INT NOT NULL,
  PRIMARY KEY (`patient_id`, `medication_id`),
  INDEX `fk_patients_has_medications_medications1_idx` (`medication_id` ASC),
  INDEX `fk_patients_has_medications_patients1_idx` (`patient_id` ASC),
  CONSTRAINT `fk_patients_has_medications_patients1`
    FOREIGN KEY (`patient_id`)
    REFERENCES `patient_history`.`patients` (`patient_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_patients_has_medications_medications1`
    FOREIGN KEY (`medication_id`)
    REFERENCES `patient_history`.`medications` (`medication_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table `patient_history`.`patients_physicians`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `patient_history`.`patients_physicians` (
  `patient_id` INT NOT NULL,
  `physician_id` INT NOT NULL,
  PRIMARY KEY (`patient_id`, `physician_id`),
  INDEX `fk_patients_has_physicians_physicians1_idx` (`physician_id` ASC),
  INDEX `fk_patients_has_physicians_patients1_idx` (`patient_id` ASC),
  CONSTRAINT `fk_patients_has_physicians_patients1`
    FOREIGN KEY (`patient_id`)
    REFERENCES `patient_history`.`patients` (`patient_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_patients_has_physicians_physicians1`
    FOREIGN KEY (`physician_id`)
    REFERENCES `patient_history`.`physicians` (`physician_id`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
