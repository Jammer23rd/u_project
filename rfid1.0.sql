-- --------------------------------------------------------
-- Anfitrião:                    127.0.0.1
-- Versão do servidor:           10.4.24-MariaDB - mariadb.org binary distribution
-- SO do servidor:               Win64
-- HeidiSQL Versão:              12.0.0.6468
-- --------------------------------------------------------

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET NAMES utf8 */;
/*!50503 SET NAMES utf8mb4 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;


-- A despejar estrutura da base de dados para rfid
CREATE DATABASE IF NOT EXISTS `rfid` /*!40100 DEFAULT CHARACTER SET utf8mb4 */;
USE `rfid`;

-- A despejar estrutura para tabela rfid.encomenda
CREATE TABLE IF NOT EXISTS `encomenda` (
  `id_ordem` smallint(8) NOT NULL DEFAULT 0,
  `id_super` smallint(10) NOT NULL,
  `id_tag` smallint(8) NOT NULL DEFAULT 0,
  `refer_inter` smallint(10) NOT NULL,
  `id_condutor` smallint(10) NOT NULL,
  `id_transporte` tinyint(3) NOT NULL,
  `local_partida` enum('Centro','Norte','Sul') NOT NULL,
  `local_destino` enum('Centro','Norte','Sul') NOT NULL,
  `estado` enum('Trânsito','Feita','Concluída','Destino') NOT NULL,
  PRIMARY KEY (`id_ordem`) USING BTREE,
  KEY `id_tag` (`id_tag`),
  KEY `refer_inter` (`refer_inter`),
  KEY `id_condutor` (`id_condutor`),
  KEY `id_super` (`id_super`),
  CONSTRAINT `FK_encomenda_produto` FOREIGN KEY (`refer_inter`) REFERENCES `produto` (`refer_inter`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `FK_encomenda_tag` FOREIGN KEY (`id_tag`) REFERENCES `tag` (`id_tag`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `FK_encomenda_tag_2` FOREIGN KEY (`id_ordem`) REFERENCES `tag` (`id_ordem`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `FK_encomenda_user` FOREIGN KEY (`id_condutor`) REFERENCES `user` (`user_id`) ON DELETE NO ACTION ON UPDATE NO ACTION,
  CONSTRAINT `FK_encomenda_user_2` FOREIGN KEY (`id_super`) REFERENCES `user` (`super_id`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='conteúdo de ordem de encomenda / transferência\r\n\r\n# id_condutor liga a id_user da tabela users\r\n# id_super liga a id_user da tabela user com tipo_user = s_user\r\n';

-- A despejar dados para tabela rfid.encomenda: ~0 rows (aproximadamente)

-- A despejar estrutura para tabela rfid.produto
CREATE TABLE IF NOT EXISTS `produto` (
  `refer_inter` smallint(10) NOT NULL COMMENT 'id unica para lote/validade/etc do mesmo produto',
  `id_prod` smallint(8) NOT NULL,
  `nome` tinytext NOT NULL,
  PRIMARY KEY (`id_prod`) USING BTREE,
  KEY `refer_inter` (`refer_inter`),
  CONSTRAINT `FK_produto_stocks` FOREIGN KEY (`refer_inter`) REFERENCES `stocks` (`refer_inter`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `FK_produto_stocks_2` FOREIGN KEY (`id_prod`) REFERENCES `stocks` (`id_prod`) ON DELETE CASCADE ON UPDATE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='listagem de produtos\r\n\r\n# refer_inter = id unica para lote/validade/etc do mesmo produto // exemplo 00232 (Produto 002 / Lote 32 )';

-- A despejar dados para tabela rfid.produto: ~0 rows (aproximadamente)

-- A despejar estrutura para tabela rfid.stocks
CREATE TABLE IF NOT EXISTS `stocks` (
  `refer_inter` smallint(10) NOT NULL COMMENT 'id unica para lote/validade/etc do mesmo produto',
  `id_prod` smallint(8) NOT NULL,
  `quantidade` tinyint(5) NOT NULL DEFAULT 0,
  `unidade` enum('CX','UN','PL') NOT NULL,
  `lote` tinytext DEFAULT NULL,
  `validade` datetime DEFAULT NULL,
  `localização` enum('Centro','Norte','Sul') NOT NULL,
  `estado` enum('Trânsito','Stock','Encomenda') NOT NULL,
  PRIMARY KEY (`refer_inter`),
  KEY `id_prod` (`id_prod`),
  KEY `localização` (`localização`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='tabela de stocks de produto';

-- A despejar dados para tabela rfid.stocks: ~0 rows (aproximadamente)

-- A despejar estrutura para tabela rfid.tag
CREATE TABLE IF NOT EXISTS `tag` (
  `id_tag` smallint(6) NOT NULL DEFAULT 0,
  `local_partida` enum('Centro','Norte','Sul') NOT NULL,
  `local_destino` enum('Centro','Norte','Sul') NOT NULL,
  `id_ordem` smallint(6) NOT NULL,
  PRIMARY KEY (`id_tag`),
  KEY `id_ordem` (`id_ordem`),
  CONSTRAINT `FK_tag_encomenda` FOREIGN KEY (`id_ordem`) REFERENCES `encomenda` (`id_ordem`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `FK_tag_encomenda_2` FOREIGN KEY (`id_tag`) REFERENCES `encomenda` (`id_tag`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='informação contida nas ''tags rfid''';

-- A despejar dados para tabela rfid.tag: ~0 rows (aproximadamente)

-- A despejar estrutura para tabela rfid.user
CREATE TABLE IF NOT EXISTS `user` (
  `user_id` smallint(5) NOT NULL,
  `tipo_user` enum('user','s_user','admin') NOT NULL,
  `nome` tinytext NOT NULL,
  `apelido` tinytext NOT NULL,
  `data_nascim` date DEFAULT NULL,
  `super_id` smallint(5) DEFAULT NULL,
  `email` char(40) NOT NULL,
  `telefone` char(40) DEFAULT NULL,
  `data_criacao_user` timestamp NOT NULL DEFAULT current_timestamp() ON UPDATE current_timestamp(),
  PRIMARY KEY (`user_id`),
  KEY `super_id` (`super_id`),
  CONSTRAINT `FK_user_encomenda` FOREIGN KEY (`super_id`) REFERENCES `encomenda` (`id_super`) ON DELETE NO ACTION ON UPDATE NO ACTION
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='base de dados de utilizadores do sistema\r\n\r\n# super_id = id super user ou supervisor';

-- A despejar dados para tabela rfid.user: ~0 rows (aproximadamente)

/*!40103 SET TIME_ZONE=IFNULL(@OLD_TIME_ZONE, 'system') */;
/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IFNULL(@OLD_FOREIGN_KEY_CHECKS, 1) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40111 SET SQL_NOTES=IFNULL(@OLD_SQL_NOTES, 1) */;
