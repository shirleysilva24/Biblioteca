-- MySQL Workbench Forward Engineering

SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='ONLY_FULL_GROUP_BY,STRICT_TRANS_TABLES,NO_ZERO_IN_DATE,NO_ZERO_DATE,ERROR_FOR_DIVISION_BY_ZERO,NO_ENGINE_SUBSTITUTION';

-- -----------------------------------------------------
-- Schema mydb
-- -----------------------------------------------------
-- -----------------------------------------------------
-- Schema prueba
-- -----------------------------------------------------

-- -----------------------------------------------------
-- Schema prueba
-- -----------------------------------------------------
CREATE SCHEMA IF NOT EXISTS `prueba` DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci ;
USE `prueba` ;

-- -----------------------------------------------------
-- Table `prueba`.`autor`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `prueba`.`autor` (
  `id_autor` INT NOT NULL AUTO_INCREMENT,
  `nombre` VARCHAR(100) NULL DEFAULT NULL,
  `fecha_nacimiento` DATE NULL DEFAULT NULL,
  `nacionalidad` VARCHAR(100) NULL DEFAULT NULL,
  `genero` ENUM('mujer', 'hombre') NULL DEFAULT NULL,
  PRIMARY KEY (`id_autor`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `prueba`.`cliente`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `prueba`.`cliente` (
  `id_cliente` INT NOT NULL,
  `nombre` VARCHAR(100) NULL DEFAULT NULL,
  `correo` VARCHAR(100) NULL DEFAULT NULL,
  `numero` VARCHAR(15) NULL DEFAULT NULL,
  `genero` ENUM('mujer', 'hombre') NULL DEFAULT NULL,
  PRIMARY KEY (`id_cliente`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `prueba`.`editorial`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `prueba`.`editorial` (
  `id_editorial` INT NOT NULL AUTO_INCREMENT,
  `nombre` VARCHAR(100) NULL DEFAULT NULL,
  PRIMARY KEY (`id_editorial`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `prueba`.`tipo_eventos`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `prueba`.`tipo_eventos` (
  `id_tipo_evento` INT NOT NULL AUTO_INCREMENT,
  `tipo_evento` VARCHAR(100) NOT NULL,
  `descripcion` VARCHAR(200) NULL DEFAULT NULL,
  PRIMARY KEY (`id_tipo_evento`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `prueba`.`evento`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `prueba`.`evento` (
  `id_evento` INT NOT NULL AUTO_INCREMENT,
  `evento` INT NULL DEFAULT NULL,
  `dia_evento` DATETIME NULL DEFAULT NULL,
  `organizador` VARCHAR(100) NULL DEFAULT NULL,
  PRIMARY KEY (`id_evento`),
  INDEX `evento` (`evento` ASC) VISIBLE,
  CONSTRAINT `evento_ibfk_1`
    FOREIGN KEY (`evento`)
    REFERENCES `prueba`.`tipo_eventos` (`id_tipo_evento`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `prueba`.`genero`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `prueba`.`genero` (
  `id_genero` INT NOT NULL AUTO_INCREMENT,
  `genero` VARCHAR(100) NULL DEFAULT NULL,
  `descripcion` VARCHAR(200) NULL DEFAULT NULL,
  PRIMARY KEY (`id_genero`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `prueba`.`tiempo`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `prueba`.`tiempo` (
  `id_tiempo` INT NOT NULL AUTO_INCREMENT,
  `fecha` TIME NULL DEFAULT NULL,
  `año` YEAR NULL DEFAULT NULL,
  `mes` INT NULL DEFAULT NULL,
  `dia` INT NULL DEFAULT NULL,
  `semana_año` INT NULL DEFAULT NULL,
  `tipo_dia` ENUM('dia de semana', 'festivo') NULL DEFAULT NULL,
  PRIMARY KEY (`id_tiempo`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `prueba`.`proveedor`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `prueba`.`proveedor` (
  `id_proveedor` INT NOT NULL AUTO_INCREMENT,
  `empresa_proveedor` VARCHAR(100) NOT NULL,
  `persona_proveedor` VARCHAR(100) NOT NULL,
  `correo` VARCHAR(100) NULL DEFAULT NULL,
  PRIMARY KEY (`id_proveedor`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `prueba`.`libro`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `prueba`.`libro` (
  `id_book` INT NOT NULL AUTO_INCREMENT,
  `nombre_book` VARCHAR(100) NOT NULL,
  `autor` INT NULL DEFAULT NULL,
  `genero` INT NULL DEFAULT NULL,
  `editorial` INT NULL DEFAULT NULL,
  `proveedor` INT NULL DEFAULT NULL,
  `cantidad_inventario` INT NULL DEFAULT NULL,
  PRIMARY KEY (`id_book`),
  INDEX `autor` (`autor` ASC) VISIBLE,
  INDEX `genero` (`genero` ASC) VISIBLE,
  INDEX `editorial` (`editorial` ASC) VISIBLE,
  INDEX `proveedor` (`proveedor` ASC) VISIBLE,
  CONSTRAINT `libro_ibfk_1`
    FOREIGN KEY (`autor`)
    REFERENCES `prueba`.`autor` (`id_autor`),
  CONSTRAINT `libro_ibfk_2`
    FOREIGN KEY (`genero`)
    REFERENCES `prueba`.`genero` (`id_genero`),
  CONSTRAINT `libro_ibfk_3`
    FOREIGN KEY (`editorial`)
    REFERENCES `prueba`.`editorial` (`id_editorial`),
  CONSTRAINT `libro_ibfk_4`
    FOREIGN KEY (`proveedor`)
    REFERENCES `prueba`.`proveedor` (`id_proveedor`))
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


-- -----------------------------------------------------
-- Table `prueba`.`hechos_ventas`
-- -----------------------------------------------------
CREATE TABLE IF NOT EXISTS `prueba`.`hechos_ventas` (
  `id_ventas` INT(10) UNSIGNED ZEROFILL NOT NULL AUTO_INCREMENT,
  `cantidad` INT NULL DEFAULT NULL,
  `total` INT NULL DEFAULT NULL,
  `tiempo_id_tiempo` INT NOT NULL,
  `cliente_id_cliente` INT NOT NULL,
  `evento_id_evento` INT NOT NULL,
  `libro_id_book` INT NOT NULL,
  PRIMARY KEY (`id_ventas`),
  INDEX `fk_hechos_ventas_tiempo1_idx` (`tiempo_id_tiempo` ASC) VISIBLE,
  INDEX `fk_hechos_ventas_cliente1_idx` (`cliente_id_cliente` ASC) VISIBLE,
  INDEX `fk_hechos_ventas_evento1_idx` (`evento_id_evento` ASC) VISIBLE,
  INDEX `fk_hechos_ventas_libro1_idx` (`libro_id_book` ASC) VISIBLE,
  CONSTRAINT `fk_hechos_ventas_tiempo1`
    FOREIGN KEY (`tiempo_id_tiempo`)
    REFERENCES `prueba`.`tiempo` (`id_tiempo`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_hechos_ventas_cliente1`
    FOREIGN KEY (`cliente_id_cliente`)
    REFERENCES `prueba`.`cliente` (`id_cliente`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_hechos_ventas_evento1`
    FOREIGN KEY (`evento_id_evento`)
    REFERENCES `prueba`.`evento` (`id_evento`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT `fk_hechos_ventas_libro1`
    FOREIGN KEY (`libro_id_book`)
    REFERENCES `prueba`.`libro` (`id_book`)
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
DEFAULT CHARACTER SET = utf8mb4
COLLATE = utf8mb4_0900_ai_ci;


SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
