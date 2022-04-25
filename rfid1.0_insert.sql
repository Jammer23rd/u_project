INSERT INTO encomenda VALUES (1, 100, 901, 555, 201, 5, `Centro`, `Norte`, `Trânsito`),
INSERT INTO encomenda VALUES (2, 111, 902, 666, 204, 4, `Sul`, `Norte`, `Feita`),
INSERT INTO encomenda VALUES (3, 122, 903, 777, 207, 3, `Centro`, `Sul`, `Feita`),
INSERT INTO encomenda VALUES (4, 133, 904, 333, 209, 2, `Centro`, `Sul`, `Trânsito`),

-- ^Dados para inserção na tabela 'encomendas'

/*`id_ordem` smallint(8) NOT NULL DEFAULT 0,
  `id_super` smallint(10) NOT NULL,
  `id_tag` smallint(8) NOT NULL DEFAULT 0, 
  `refer_inter` smallint(10) NOT NULL, ((((((((???))))))))
  `id_condutor` smallint(10) NOT NULL,
  `id_transporte` tinyint(3) NOT NULL,
  `local_partida` enum('Centro','Norte','Sul') NOT NULL,
  `local_destino` enum('Centro','Norte','Sul') NOT NULL,
  `estado` enum('Trânsito','Feita','Concluída','Destino') NOT NULL,
*/



INSERT INTO produto VALUES (555, 00110, 'Cola'),
INSERT INTO produto VALUES (544, 00210, '7up'),
INSERT INTO produto VALUES (533, 00310, 'Água'),
INSERT INTO produto VALUES (522, 00410, 'Gin'),
INSERT INTO produto VALUES (511, 00510, 'Mate'),
INSERT INTO produto VALUES (566, 00610, 'RedBull'),


-- ^Dados para inserção na tabela 'produto'

/*  REATE TABLE IF NOT EXISTS `produto` (
  `refer_inter` smallint(10) NOT NULL COMMENT 'id unica para lote/validade/etc do mesmo produto',
  `id_prod` smallint(8) NOT NULL,
  `nome` tinytext NOT NULL,
  PRIMARY KEY (`id_prod`) USING BTREE,
  KEY `refer_inter` (`refer_inter`),
  CONSTRAINT `FK_produto_stocks` FOREIGN KEY (`refer_inter`) REFERENCES `stocks` (`refer_inter`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `FK_produto_stocks_2` FOREIGN KEY (`id_prod`) REFERENCES `stocks` (`id_prod`) ON DELETE CASCADE ON UPDATE CASCADE
  */


INSERT INTO stocks VALUES (555, 00110, 10, UN, LT1COLA, 20250202, 'Centro', 'Stock'),
INSERT INTO stocks VALUES (444, 00156, 3, CX, 09898, 20230902, 'Norte', 'Stock'),
INSERT INTO stocks VALUES (555, 00156, 15, CX, GULP1, 20250506, 'Centro', 'Trânsito'),
INSERT INTO stocks VALUES (555, 00133, 123, CX, LT78PPP, 20651202, 'Sul', 'Stock'),
INSERT INTO stocks VALUES (555, 00187, 1, UN, LT345L, 20230912, 'Norte', 'Stock'),
INSERT INTO stocks VALUES (555, 00119, 199, PL, GGGGG, 20291212, 'Sul', 'Trânsito'),

-- ^Dados para inserção na tabela 'stocks'

/*
  CREATE TABLE IF NOT EXISTS `stocks` (
  `refer_inter` smallint(10) NOT NULL COMMENT 'id unica para lote/validade/etc do mesmo produto',
  `id_prod` smallint(8) NOT NULL,
  `quantidade` tinyint(5) NOT NULL DEFAULT 0,
  `unidade` enum('CX','UN','PL') NOT NULL,
  `lote` tinytext DEFAULT NULL,
  `validade` datetime DEFAULT NULL,
  `localização` enum('Centro','Norte','Sul') NOT NULL,
  `estado` enum('Trânsito','Stock','Encomenda') NOT NULL,
  */

INSERT INTO tag VALUES (901, 'Centro', 'Norte'),
INSERT INTO tag VALUES (901), 'Sul', 'Norte'),
INSERT INTO tag VALUES (902, 'Norte', 'Sul'),
INSERT INTO tag VALUES (904, 'Centro', 'Sul'),
INSERT INTO tag VALUES (905, 'Norte', 'Sul'),
INSERT INTO tag VALUES (901, 'Centro', 'Sul'),
INSERT INTO tag VALUES (906, 'Centro', 'Norte'),

-- ^Dados para inserção na tabela 'tag'

/*
  REATE TABLE IF NOT EXISTS `tag` (
  `id_tag` smallint(6) NOT NULL DEFAULT 0,
  `local_partida` enum('Centro','Norte','Sul') NOT NULL,
  `local_destino` enum('Centro','Norte','Sul') NOT NULL,
  `id_ordem` smallint(6) NOT NULL,
  PRIMARY KEY (`id_tag`),
  KEY `id_ordem` (`id_ordem`),
  CONSTRAINT `FK_tag_encomenda` FOREIGN KEY (`id_ordem`) REFERENCES `encomenda` (`id_ordem`) ON DELETE CASCADE ON UPDATE CASCADE,
  CONSTRAINT `FK_tag_encomenda_2` FOREIGN KEY (`id_tag`) REFERENCES `encomenda` (`id_tag`) ON DELETE NO ACTION ON UPDATE NO ACTION
  */

INSERT INTO user VALUES (101, 'user', 'José', 'Pires', 19550211, NULL, 'josep@empresa.xx', 919191111),
INSERT INTO user VALUES (102, 's_user', 'Maria', 'Silva', 19660211, NULL, 'f0d4555@empresa.xx', 915326856),
INSERT INTO user VALUES (122, 'user', 'Marco', 'Costa', 19990911, NULL, 'cratividade1@empresa.xx', 0035191587566),
INSERT INTO user VALUES (133, 'user', 'Luisa', 'Brois', 19550521, NULL, 'oemaildooutro@empresa.xx', 0102254566585),
INSERT INTO user VALUES (161, 'user', 'José', 'Salgueiro', 20051211, NULL, 'omeuemail@empresa.xx', 002257866548),
INSERT INTO user VALUES (103, 'admin', 'Simão', 'Pinhel', 19780909, NULL, 'admin@empresa.xx', 9356585254),

-- ^Dados para inserção na tabela 'user'

/*
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