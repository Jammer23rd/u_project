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
DROP DATABASE IF EXISTS `rfid`;
CREATE DATABASE IF NOT EXISTS `rfid` /*!40100 DEFAULT CHARACTER SET utf8mb4 */;
USE `rfid`;

-- A despejar estrutura para tabela rfid.encomenda
DROP TABLE IF EXISTS `encomenda`;
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
  KEY `id_super` (`id_super`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='conteúdo de ordem de encomenda / transferência\r\n\r\n# id_condutor liga a id_user da tabela users\r\n# id_super liga a id_user da tabela user com tipo_user = s_user\r\n';

-- A despejar dados para tabela rfid.encomenda: ~4 rows (aproximadamente)
/*!40000 ALTER TABLE `encomenda` DISABLE KEYS */;
INSERT INTO `encomenda` (`id_ordem`, `id_super`, `id_tag`, `refer_inter`, `id_condutor`, `id_transporte`, `local_partida`, `local_destino`, `estado`) VALUES
	(1, 100, 901, 555, 201, 5, 'Centro', 'Norte', 'Trânsito'),
	(2, 111, 902, 666, 204, 4, 'Sul', 'Norte', 'Feita'),
	(3, 122, 903, 777, 207, 3, 'Centro', 'Sul', 'Feita'),
	(4, 133, 904, 333, 209, 2, 'Centro', 'Sul', 'Trânsito');
/*!40000 ALTER TABLE `encomenda` ENABLE KEYS */;

-- A despejar estrutura para tabela rfid.produto
DROP TABLE IF EXISTS `produto`;
CREATE TABLE IF NOT EXISTS `produto` (
  `refer_inter` smallint(10) NOT NULL COMMENT 'id unica para lote/validade/etc do mesmo produto',
  `id_prod` smallint(8) NOT NULL,
  `nome` tinytext NOT NULL,
  PRIMARY KEY (`id_prod`) USING BTREE,
  KEY `refer_inter` (`refer_inter`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='listagem de produtos\r\n\r\n# refer_inter = id unica para lote/validade/etc do mesmo produto // exemplo 00232 (Produto 002 / Lote 32 )';

-- A despejar dados para tabela rfid.produto: ~6 rows (aproximadamente)
/*!40000 ALTER TABLE `produto` DISABLE KEYS */;
INSERT INTO `produto` (`refer_inter`, `id_prod`, `nome`) VALUES
	(555, 110, 'Cola'),
	(544, 210, '7up'),
	(533, 310, 'Água'),
	(522, 410, 'Gin'),
	(511, 510, 'Mate'),
	(566, 610, 'RedBull');
/*!40000 ALTER TABLE `produto` ENABLE KEYS */;

-- A despejar estrutura para tabela rfid.stocks
DROP TABLE IF EXISTS `stocks`;
CREATE TABLE IF NOT EXISTS `stocks` (
  `refer_inter` smallint(10) NOT NULL COMMENT 'id unica para lote/validade/etc do mesmo produto',
  `id_prod` smallint(8) NOT NULL,
  `quantidade` tinyint(5) NOT NULL DEFAULT 0,
  `unidade` enum('CX','UN','PL') NOT NULL,
  `lote` tinytext DEFAULT NULL,
  `validade` date DEFAULT NULL,
  `localização` enum('Centro','Norte','Sul') NOT NULL,
  `estado` enum('Trânsito','Stock','Encomenda') NOT NULL,
  PRIMARY KEY (`refer_inter`),
  KEY `id_prod` (`id_prod`),
  KEY `localização` (`localização`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='tabela de stocks de produto';

-- A despejar dados para tabela rfid.stocks: ~6 rows (aproximadamente)
/*!40000 ALTER TABLE `stocks` DISABLE KEYS */;
INSERT INTO `stocks` (`refer_inter`, `id_prod`, `quantidade`, `unidade`, `lote`, `validade`, `localização`, `estado`) VALUES
	(444, 156, 3, 'CX', '9898', '2023-09-02', 'Norte', 'Stock'),
	(555, 110, 10, 'UN', 'LT1COLA', '2025-02-02', 'Centro', 'Stock'),
	(666, 156, 15, 'CX', 'GULP1', '2025-05-06', 'Centro', 'Trânsito'),
	(777, 133, 123, 'CX', 'LT78PPP', '2065-12-02', 'Sul', 'Stock'),
	(888, 187, 1, 'UN', 'LT345L', '2023-09-12', 'Norte', 'Stock'),
	(999, 119, 127, 'PL', 'GGGGG', '2029-12-12', 'Sul', 'Trânsito');
/*!40000 ALTER TABLE `stocks` ENABLE KEYS */;

-- A despejar estrutura para tabela rfid.tag
DROP TABLE IF EXISTS `tag`;
CREATE TABLE IF NOT EXISTS `tag` (
  `id_tag` smallint(6) NOT NULL DEFAULT 0,
  `local_partida` enum('Centro','Norte','Sul') NOT NULL,
  `local_destino` enum('Centro','Norte','Sul') NOT NULL,
  `id_ordem` smallint(6) NOT NULL,
  PRIMARY KEY (`id_tag`),
  KEY `id_ordem` (`id_ordem`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='informação contida nas ''tags rfid''';

-- A despejar dados para tabela rfid.tag: ~6 rows (aproximadamente)
/*!40000 ALTER TABLE `tag` DISABLE KEYS */;
INSERT INTO `tag` (`id_tag`, `local_partida`, `local_destino`, `id_ordem`) VALUES
	(900, 'Centro', 'Norte', 20),
	(901, 'Sul', 'Norte', 21),
	(902, 'Norte', 'Sul', 22),
	(904, 'Centro', 'Sul', 23),
	(905, 'Norte', 'Sul', 24),
	(907, 'Centro', 'Sul', 25);
/*!40000 ALTER TABLE `tag` ENABLE KEYS */;

-- A despejar estrutura para tabela rfid.user
DROP TABLE IF EXISTS `user`;
CREATE TABLE IF NOT EXISTS `user` (
  `user_id` smallint(5) NOT NULL,
  `tipo_user` enum('user','s_user','admin') NOT NULL,
  `nome` tinytext NOT NULL,
  `apelido` tinytext NOT NULL,
  `data_nascim` date DEFAULT NULL,
  `super_id` smallint(5) DEFAULT NULL,
  `email` char(40) NOT NULL,
  `telefone` char(40) DEFAULT NULL,
  `data_criacao` timestamp NULL DEFAULT NULL,
  PRIMARY KEY (`user_id`),
  KEY `super_id` (`super_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='base de dados de utilizadores do sistema\r\n\r\n# super_id = id super user ou supervisor';

-- A despejar dados para tabela rfid.user: ~0 rows (aproximadamente)
/*!40000 ALTER TABLE `user` DISABLE KEYS */;
/*!40000 ALTER TABLE `user` ENABLE KEYS */;

/*!40101 SET SQL_MODE=IFNULL(@OLD_SQL_MODE, '') */;
/*!40014 SET FOREIGN_KEY_CHECKS=IFNULL(@OLD_FOREIGN_KEY_CHECKS, 1) */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40111 SET SQL_NOTES=IFNULL(@OLD_SQL_NOTES, 1) */;
