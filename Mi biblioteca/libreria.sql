CREATE DATABASE  IF NOT EXISTS `mi_libreria` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_0900_ai_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;
USE `mi_libreria`;
 

DROP TABLE IF EXISTS `author`;
CREATE TABLE `author` (
  `id` int NOT NULL AUTO_INCREMENT,
  `author` varchar(100) NOT NULL,
  `birth` date DEFAULT NULL,
  `nationality` varchar(100) DEFAULT NULL,
  `mother_tongue` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`id`)
) ;

 
 
CREATE TABLE `editorial` (
  `id` int NOT NULL AUTO_INCREMENT,
  `editorial` varchar(100) NOT NULL,
  `format` varchar(50) NOT NULL,
  `Foundation` date DEFAULT NULL,
  PRIMARY KEY (`id`)
)  ;




-- Eliminar tabla
 
CREATE TABLE `format` (
  `id` int NOT NULL AUTO_INCREMENT,
  `format` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`id`)
)  ;


 
 
CREATE TABLE `gender` (
  `id` int NOT NULL AUTO_INCREMENT,
  `gender` varchar(50) NOT NULL,
  `depcription` varchar(100) NOT NULL,
  PRIMARY KEY (`id`)
  ); 
  
  -- Tabla relacional entre gender y book ya que es una relacion de muchos a muchos
  CREATE TABLE book_gender(
  id INT  NOT NULL AUTO_INCREMENT PRIMARY KEY   ,
  book_id INT,
  gender_id INT ,
  constraint book_id_book_gender FOREIGN KEY (book_id) REFERENCES book(id),
constraint  gender_id_book_gender FOREIGN KEY (gender_id) REFERENCES gender(id)
  );


CREATE TABLE `ranking` (
  `id` int NOT NULL AUTO_INCREMENT,
  `ranking` varchar(40) DEFAULT NULL,
  PRIMARY KEY (`id`)
)  ;


 
CREATE TABLE `interest_book` (
  `id` int NOT NULL AUTO_INCREMENT,
  `id_book` int NOT NULL,
  `remark` varchar(150) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_interest_book` (`id_book`),
  CONSTRAINT `fk_interest_book` FOREIGN KEY (`id_book`) REFERENCES `book` (`id`)
) ;

alter table interest_book
modify column remark varchar(500) default null;

 
CREATE TABLE `pending_book` (
  `id` int NOT NULL AUTO_INCREMENT,
  `id_book` int NOT NULL,
  `purchase_date` date DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_pending_book` (`id_book`),
  CONSTRAINT `fk_pending_book` FOREIGN KEY (`id_book`) REFERENCES `book` (`id`)
)  ;
 
 


CREATE TABLE `read_book` (
  `id` int NOT NULL AUTO_INCREMENT,
  `id_book` int NOT NULL,
  `start_read` date DEFAULT NULL,
  `finish_read` date DEFAULT NULL,
  `id_ranking` int NOT NULL,
  `opinion` varchar(150) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_read_book` (`id_book`),
  KEY `fk_interest_ranking` (`id_ranking`),
  CONSTRAINT `fk_interest_ranking` FOREIGN KEY (`id_ranking`) REFERENCES `ranking` (`id`),
  CONSTRAINT `fk_read_book` FOREIGN KEY (`id_book`) REFERENCES `book` (`id`)
)  ;

CREATE TABLE `book` (
  `id` int NOT NULL AUTO_INCREMENT,
  `name_author_id` int DEFAULT NULL,
  `page` int DEFAULT NULL,
  `editorial_id` int NOT NULL,
  `publication` varchar(100) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `fk_book_author` (`name_author_id`),
  KEY `fk_book_gender` (`gender_id`),
  KEY `fk_book_editorial` (`editorial_id`),
  KEY `fk_book_format` (`format_id`),
  CONSTRAINT `fk_book_author` FOREIGN KEY (`name_author_id`) REFERENCES `author` (`id`),
  CONSTRAINT `fk_book_editorial` FOREIGN KEY (`editorial_id`) REFERENCES `editorial` (`id`)
 
) ;

 


-- Insertar datos de autor
INSERT INTO author (author, birth, nationality, mother_tongue)
VALUES
("Jorge Franco", "1962-02-22", "Colombia", "Español"),
("Colleen McCullough", "1937-01-06", "Australia", "Inglés"),
("John Katzenbach", "1950-06-23", "EE. UU.", "Inglés"),
("Umberto Eco", "1932-05-01", "Italia", NULL),
("Scott Hawkins", NULL, NULL, NULL);

-- iNSERTAR DATOS DE EDITORIAL

INSERT INTO editorial (editorial,format)
values
("Editorial Hidra", "Fisico"),
("Editorial Hidra", "Fisico"),
("Cuatro por cuatro Editoriales", "Fisico"),
(" Pnguin Random House", "Fisico"),
("Ediciones b", "Fisico");


-- Insertar datos en Genero
INSERT INTO `gender` (`gender`, `depcription`)
VALUES
("Ficción", "Libros de ficción general"),
("No ficción", "Libros basados en hechos reales"),
("Misterio", "Libros de misterio y suspense"),
("Ciencia ficción", "Libros de ciencia ficción"),
("Romance", "Libros románticos");

-- Insertar datos la calificacion
INSERT INTO `ranking` (`ranking`)
VALUES
("1"),
("2"),
("3"),
("4"),
("5");

 



 



