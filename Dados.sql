/*
SQLyog Community v13.2.1 (64 bit)
MySQL - 8.0.39 : Database - wktec
*********************************************************************
*/

/*!40101 SET NAMES utf8 */;

/*!40101 SET SQL_MODE=''*/;

/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;
CREATE DATABASE /*!32312 IF NOT EXISTS*/`wktec` /*!40100 DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci */ /*!80016 DEFAULT ENCRYPTION='N' */;

USE `wktec`;

/*Table structure for table `clientes` */

DROP TABLE IF EXISTS `clientes`;

CREATE TABLE `clientes` (
  `codigo` int NOT NULL AUTO_INCREMENT,
  `nome` varchar(40) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `cidade` varchar(30) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `uf` varchar(2) COLLATE utf8mb4_general_ci DEFAULT NULL,
  PRIMARY KEY (`codigo`)
) ENGINE=InnoDB AUTO_INCREMENT=11 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

/*Data for the table `clientes` */

insert  into `clientes`(`codigo`,`nome`,`cidade`,`uf`) values 
(1,'João Ferreira da Silva','Niterói','RJ'),
(2,'Carolina Andrade Neves','Itaboraí','RJ'),
(3,'Marina de Oliveira','Juiz de Fora','MG'),
(4,'Giovanna Ferraz','Vila Velha','ES'),
(5,'Paulo Gomes','Santo André','SP'),
(6,'Patrícia Dantas','Cambé','PR'),
(7,'Jonathan Lima','Florianopolis','SC'),
(8,'Gordon Ramsay','Cuiabá','MT'),
(9,'Lissa Wanderpump','Campo Grande','MS'),
(10,'Mika Kleinsmith','Lauro de Freitas','BA');

/*Table structure for table `pedidos_dados_gerais` */

DROP TABLE IF EXISTS `pedidos_dados_gerais`;

CREATE TABLE `pedidos_dados_gerais` (
  `num_pedido` int NOT NULL AUTO_INCREMENT,
  `data_emissao` date DEFAULT NULL,
  `cod_cliente` int DEFAULT NULL,
  `valor_total` decimal(10,0) DEFAULT NULL,
  PRIMARY KEY (`num_pedido`),
  KEY `ped_clientes` (`cod_cliente`),
  CONSTRAINT `ped_clientes` FOREIGN KEY (`cod_cliente`) REFERENCES `clientes` (`codigo`)
) ENGINE=InnoDB AUTO_INCREMENT=5 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

/*Data for the table `pedidos_dados_gerais` */

insert  into `pedidos_dados_gerais`(`num_pedido`,`data_emissao`,`cod_cliente`,`valor_total`) values 
(3,'2024-10-08',1,119),
(4,'2024-10-08',5,58);

/*Table structure for table `pedidos_produtos` */

DROP TABLE IF EXISTS `pedidos_produtos`;

CREATE TABLE `pedidos_produtos` (
  `id` int NOT NULL AUTO_INCREMENT,
  `num_pedido` int NOT NULL,
  `cod_produto` int DEFAULT NULL,
  `quant` int DEFAULT NULL,
  `vlr_unitario` decimal(10,0) DEFAULT NULL,
  `vlr_total` decimal(10,0) DEFAULT NULL,
  PRIMARY KEY (`id`),
  KEY `produtos_pedidos1` (`cod_produto`),
  CONSTRAINT `produtos_pedidos1` FOREIGN KEY (`cod_produto`) REFERENCES `produtos` (`codigo`)
) ENGINE=InnoDB AUTO_INCREMENT=10 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

/*Data for the table `pedidos_produtos` */

insert  into `pedidos_produtos`(`id`,`num_pedido`,`cod_produto`,`quant`,`vlr_unitario`,`vlr_total`) values 
(4,3,6,3,7,21),
(5,3,8,4,20,80),
(6,3,1,3,6,18),
(7,4,10,2,15,30),
(8,4,7,2,8,16),
(9,4,1,2,6,12);

/*Table structure for table `produtos` */

DROP TABLE IF EXISTS `produtos`;

CREATE TABLE `produtos` (
  `codigo` int NOT NULL AUTO_INCREMENT,
  `descricao` varchar(45) COLLATE utf8mb4_general_ci DEFAULT NULL,
  `preco_venda` float DEFAULT NULL,
  PRIMARY KEY (`codigo`)
) ENGINE=InnoDB AUTO_INCREMENT=23 DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_general_ci;

/*Data for the table `produtos` */

insert  into `produtos`(`codigo`,`descricao`,`preco_venda`) values 
(1,'Suco de Laranja 300ml',6),
(2,'Suco de Laranja 500ml',9),
(3,'Suco de Uva 300ml',6),
(4,'Suco de Uva 500ml',9),
(5,'BK Chicken',12),
(6,'BK Chesse',7),
(7,'BK Cheese Bacon',8),
(8,'BK Furioso',20),
(9,'BK Chicken JR',7),
(10,'Whooper JR',15),
(11,'Whooper ',22),
(12,'Whooper Furioso',26),
(13,'BK Veggie',27),
(14,'BK Fritas Pequena',8),
(15,'BK Fritas Média',12),
(16,'BK Fritas Grande',15),
(17,'BK Fritas com Cheddar',20),
(18,'BK Onion Rings',10),
(19,'Refrigerante Refil',18),
(20,'Sundae Morango',8),
(21,'Sundae Chocolate',8),
(22,'Sundae Caramelo',8);

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;
