CREATE TABLE IF NOT EXISTS `owned_keys` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `identifier` varchar(50) NOT NULL,
  `plate` varchar(12) NOT NULL,
  `type` int(1) NOT NULL,

  PRIMARY KEY (`id`)
);

ALTER TABLE `owned_keys` CHANGE `id` `id` INT NOT NULL AUTO_INCREMENT;