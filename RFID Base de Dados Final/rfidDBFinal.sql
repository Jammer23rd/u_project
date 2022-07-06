-- --------------------------------------------------------
-- Anfitrião:                    127.0.0.1
-- Versão do servidor:           10.4.24-MariaDB - mariadb.org binary distribution
-- SO do servidor:               Win64
-- HeidiSQL Versão:              11.3.0.6295
-- --------------------------------------------------------

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET NAMES utf8 */;
/*!50503 SET NAMES utf8mb4 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;


-- A despejar estrutura da base de dados para rfid
CREATE DATABASE IF NOT EXISTS `rfid` /*!40100 DEFAULT CHARACTER SET utf8mb4 */;
USE `rfid`;

-- A despejar estrutura para tabela rfid.cliente
CREATE TABLE IF NOT EXISTS `cliente` (
  `ID_client` smallint(6) NOT NULL DEFAULT 0,
  `Morada` varchar(200) NOT NULL,
  `morada_id` smallint(6) NOT NULL DEFAULT 0,
  `ID_user` smallint(6) NOT NULL AUTO_INCREMENT,
  KEY `ID_user` (`ID_user`),
  KEY `morada_id` (`morada_id`),
  KEY `ID_client` (`ID_client`),
  KEY `Morada` (`Morada`),
  CONSTRAINT `FK_cliente_user` FOREIGN KEY (`ID_user`) REFERENCES `user` (`ID_user`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4;

-- Exportação de dados não seleccionada.

-- A despejar estrutura para tabela rfid.encomenda
CREATE TABLE IF NOT EXISTS `encomenda` (
  `ID_enc` smallint(6) NOT NULL,
  `ID_fatura` smallint(6) NOT NULL,
  `notas` varchar(150) DEFAULT NULL,
  `ID_tag` smallint(6) NOT NULL,
  `ID_cliente` smallint(6) NOT NULL,
  PRIMARY KEY (`ID_enc`),
  KEY `ID_tag` (`ID_tag`),
  KEY `ID_cliente` (`ID_cliente`),
  CONSTRAINT `FK_encomenda_cliente` FOREIGN KEY (`ID_cliente`) REFERENCES `cliente` (`ID_client`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `FK_encomenda_tags` FOREIGN KEY (`ID_tag`) REFERENCES `tags` (`ID_tag`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `FK_encomenda_tags_2` FOREIGN KEY (`ID_enc`) REFERENCES `tags` (`ID_enc`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Exportação de dados não seleccionada.

-- A despejar estrutura para tabela rfid.localização
CREATE TABLE IF NOT EXISTS `localização` (
  `ID_tag` smallint(6) NOT NULL,
  `cord_x` int(11) NOT NULL DEFAULT 0,
  `cord_y` int(11) NOT NULL DEFAULT 0,
  `estado` enum('Em trânsito','Entregue') NOT NULL,
  `destino` varchar(200) NOT NULL,
  PRIMARY KEY (`ID_tag`),
  KEY `FK_localização_morada` (`destino`),
  CONSTRAINT `FK_localização_morada` FOREIGN KEY (`destino`) REFERENCES `morada` (`rua`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `FK_localização_tags` FOREIGN KEY (`ID_tag`) REFERENCES `tags` (`ID_tag`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Exportação de dados não seleccionada.

-- A despejar estrutura para tabela rfid.morada
CREATE TABLE IF NOT EXISTS `morada` (
  `morada_id` smallint(6) NOT NULL,
  `codigo_postal` smallint(6) NOT NULL,
  `rua` varchar(200) NOT NULL,
  `cidade` varchar(200) NOT NULL,
  PRIMARY KEY (`morada_id`),
  KEY `rua` (`rua`),
  CONSTRAINT `FK_morada_cliente` FOREIGN KEY (`morada_id`) REFERENCES `cliente` (`morada_id`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `FK_morada_cliente_2` FOREIGN KEY (`rua`) REFERENCES `cliente` (`Morada`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- Exportação de dados não seleccionada.

-- A despejar estrutura para tabela rfid.tags
CREATE TABLE IF NOT EXISTS `tags` (
  `ID_tag` smallint(6) NOT NULL DEFAULT 0,
  `ID_user` smallint(6) NOT NULL AUTO_INCREMENT,
  `ID_enc` smallint(6) NOT NULL,
  PRIMARY KEY (`ID_tag`) USING BTREE,
  KEY `ID_user` (`ID_user`),
  KEY `ID_enc` (`ID_enc`),
  CONSTRAINT `FK_tags_user` FOREIGN KEY (`ID_user`) REFERENCES `user` (`ID_user`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4;

-- Exportação de dados não seleccionada.

-- A despejar estrutura para tabela rfid.user
CREATE TABLE IF NOT EXISTS `user` (
  `ID_user` smallint(6) NOT NULL AUTO_INCREMENT,
  `username` varchar(100) NOT NULL,
  `password` varchar(50) NOT NULL,
  `user_role` enum('Admin','user') NOT NULL,
  `user_status` enum('Ativo','Inativo') NOT NULL,
  PRIMARY KEY (`ID_user`)
) ENGINE=InnoDB AUTO_INCREMENT=8 DEFAULT CHARSET=utf8mb4 ROW_FORMAT=DYNAMIC;

-- Exportação de dados não seleccionada.

/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IFNULL(@OLD_FOREIGN_KEY_CHECKS, 1) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40111 SET SQL_NOTES=IFNULL(@OLD_SQL_NOTES, 1) */;
