-- phpMyAdmin SQL Dump
-- version 4.2.7.1
-- http://www.phpmyadmin.net
--
-- Client :  localhost
-- Généré le :  Lun 15 Mars 2021 à 07:55
-- Version du serveur :  5.6.20-log
-- Version de PHP :  7.2.7

SET SQL_MODE = "NO_AUTO_VALUE_ON_ZERO";
SET time_zone = "+00:00";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;

--
-- Base de données :  `adezou`
--

-- --------------------------------------------------------

--
-- Structure de la table `accounts_logs`
--

CREATE TABLE IF NOT EXISTS `accounts_logs` (
`id` int(11) NOT NULL,
  `identifier_origin` varchar(50) NOT NULL,
  `account_origin` varchar(30) NOT NULL,
  `identifier_target` varchar(30) NOT NULL,
  `account_target` varchar(30) NOT NULL,
  `type` varchar(50) NOT NULL,
  `amount` int(11) NOT NULL
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=736 ;

-- --------------------------------------------------------

--
-- Structure de la table `account_logs`
--

CREATE TABLE IF NOT EXISTS `account_logs` (
  `id` varchar(30) NOT NULL,
  `type` varchar(30) NOT NULL,
  `society` varchar(20) NOT NULL,
  `amount` varchar(15) NOT NULL,
  `new` varchar(15) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Structure de la table `addon_account`
--

CREATE TABLE IF NOT EXISTS `addon_account` (
  `name` varchar(60) NOT NULL,
  `label` varchar(255) NOT NULL,
  `shared` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Contenu de la table `addon_account`
--

INSERT INTO `addon_account` (`name`, `label`, `shared`) VALUES
('bank_savings', 'Livret Bleu', 0),
('biker_lost', 'The Lost', 1),
('biker_lost_black', 'The Lost', 1),
('caution', 'Caution', 0),
('gang_ballas', 'Ballas', 1),
('gang_ballas_black', 'Ballas', 1),
('gang_families', 'Families', 1),
('gang_families_black', 'Families', 1),
('gang_vagos', 'Vagos', 1),
('gang_vagos_black', 'Vagos', 1),
('orga_celtic', 'Celtic', 1),
('orga_celtic_black', 'Celtic', 1),
('orga_ordre', 'L''ordre', 1),
('orga_ordre_black', 'L''ordre', 1),
('property_black_money', 'Argent Sale Propriété', 0),
('society_ambulance', 'Ambulance', 1),
('society_ammunation', 'Ammunation', 1),
('society_bahama', 'Bahama Mas', 1),
('society_cluckin', 'Cluckin Bell', 1),
('society_ems', 'EMS', 1),
('society_mecano', 'Mecano', 1),
('society_nightclub', 'Galaxy', 1),
('society_police', 'LSPD', 1),
('society_police_black', 'LSPD Black Money', 1),
('society_state', 'Gouv', 1),
('society_tailor', 'Couturier', 1),
('society_taxi', 'Taxi', 1),
('society_unicorn', 'Unicorn', 1),
('society_vigne', 'Vigneron', 1),
('society_vigneron', 'Vigneron', 1);

-- --------------------------------------------------------

--
-- Structure de la table `addon_account_data`
--

CREATE TABLE IF NOT EXISTS `addon_account_data` (
`id` int(11) NOT NULL,
  `account_name` varchar(255) DEFAULT NULL,
  `money` double NOT NULL,
  `owner` varchar(255) DEFAULT NULL
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=683 ;

--
-- Contenu de la table `addon_account_data`
--

INSERT INTO `addon_account_data` (`id`, `account_name`, `money`, `owner`) VALUES
(4, 'society_ammunation', 299855, NULL),
(6, 'society_bahama', 68660, NULL),
(31, 'society_mecano', 9904643.900000002, NULL),
(39, 'society_police', 196553, NULL),
(44, 'society_state', 1314807, NULL),
(48, 'society_taxi', 50000, NULL),
(49, 'society_unicorn', 50000, NULL),
(303, 'society_police_black', 15, NULL),
(432, 'society_ambulance', 57124, NULL),
(617, 'society_vigneron', 108566, NULL),
(663, 'society_tailor', 31672, NULL),
(667, 'society_cluckin', 230, NULL),
(668, 'society_nightclub', 0, NULL),
(669, 'society_vigne', 0, NULL),
(670, 'society_ems', 3680, NULL),
(671, 'gang_vagos', 51, NULL),
(672, 'gang_vagos_black', 50, NULL),
(673, 'gang_ballas', 0, NULL),
(674, 'gang_ballas_black', 0, NULL),
(675, 'gang_families', 0, NULL),
(676, 'gang_families_black', 0, NULL),
(677, 'biker_lost', 0, NULL),
(678, 'biker_lost_black', 10, NULL),
(679, 'orga_celtic', 0, NULL),
(680, 'orga_celtic_black', 0, NULL),
(681, 'orga_ordre', 0, NULL),
(682, 'orga_ordre_black', 0, NULL);

-- --------------------------------------------------------

--
-- Structure de la table `addon_inventory`
--

CREATE TABLE IF NOT EXISTS `addon_inventory` (
  `name` varchar(60) NOT NULL,
  `label` varchar(255) NOT NULL,
  `shared` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Contenu de la table `addon_inventory`
--

INSERT INTO `addon_inventory` (`name`, `label`, `shared`) VALUES
('biker_lost', 'The Lost', 1),
('gang_ballas', 'Ballas', 1),
('gang_families', 'Families', 1),
('gang_vagos', 'Vagos', 1),
('orga_celtic', 'Celtic', 1),
('orga_ordre', 'L''ordre', 1),
('property', 'Propriété', 0),
('society_ambulance', 'Ambulance', 1),
('society_ammunation', 'Ammunation', 1),
('society_bahama', 'Bahama Mas', 1),
('society_cluckin', 'Cluckin Bell', 1),
('society_ems', 'EMS', 1),
('society_mecano', 'Mécano', 1),
('society_nightclub', 'Galaxy', 1),
('society_police', 'Police', 1),
('society_state', 'State', 1),
('society_tailor', 'Couturier', 1),
('society_taxi', 'Taxi', 1),
('society_unicorn', 'Unicorn', 1),
('society_vigneron', 'Vigneron', 1);

-- --------------------------------------------------------

--
-- Structure de la table `addon_inventory_items`
--

CREATE TABLE IF NOT EXISTS `addon_inventory_items` (
`id` int(11) NOT NULL,
  `inventory_name` varchar(255) NOT NULL,
  `name` varchar(255) NOT NULL,
  `count` int(11) NOT NULL,
  `owner` varchar(60) DEFAULT NULL
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=154 ;

--
-- Contenu de la table `addon_inventory_items`
--

INSERT INTO `addon_inventory_items` (`id`, `inventory_name`, `name`, `count`, `owner`) VALUES
(120, 'society_ammunation', 'clip', 0, NULL),
(131, 'society_mecano', 'fixkit', 70, NULL),
(132, 'society_mecano', 'carokit', 70, NULL),
(133, 'society_state', 'clip', 20, NULL),
(134, 'society_taxi', 'carokit', 0, NULL),
(135, 'society_taxi', 'fixkit', 10, NULL),
(136, 'society_vigneron', 'woodenbox', 0, NULL),
(137, 'society_taxi', 'champagnebox', 1, NULL),
(138, 'society_taxi', 'grand_crubox', 1, NULL),
(139, 'society_taxi', 'jus_raisinbox', 1, NULL),
(140, 'society_taxi', 'vinebox', 1, NULL),
(141, 'society_vigneron', 'raisin', 0, NULL),
(144, 'society_taxi', 'grand_cru', 40, NULL),
(145, 'society_unicorn', 'nuggets', 0, NULL),
(146, 'society_ammunation', 'steel', 5, NULL),
(147, 'gang_vagos', 'weapon_hammer', 1, NULL),
(148, 'society_ammunation', 'weapon_hammer', 0, NULL),
(149, 'gang_vagos', 'weapon_hazardcan', 1, NULL),
(150, 'society_ammunation', 'weapon_hazardcan', 0, NULL),
(151, 'gang_vagos', 'donut', 12, NULL),
(152, 'gang_vagos', 'potato', 1, NULL),
(153, 'gang_vagos', 'clip', 1, NULL);

-- --------------------------------------------------------

--
-- Structure de la table `ban_list`
--

CREATE TABLE IF NOT EXISTS `ban_list` (
  `steam` varchar(50) NOT NULL DEFAULT 'not_found',
  `license` varchar(50) NOT NULL,
  `discord` varchar(30) NOT NULL DEFAULT 'not_found',
  `ip` varchar(30) NOT NULL DEFAULT 'not_found',
  `xbl` varchar(30) NOT NULL DEFAULT 'not_found',
  `live` varchar(30) NOT NULL DEFAULT 'not_found',
  `name` varchar(255) NOT NULL DEFAULT 'not_found' COMMENT 'steam name of the user',
  `reason` varchar(255) NOT NULL,
  `staff` varchar(50) NOT NULL COMMENT 'steam id of the staff who banned the player',
  `date_ban` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Structure de la table `billing`
--

CREATE TABLE IF NOT EXISTS `billing` (
`id` int(11) NOT NULL,
  `identifier` varchar(255) NOT NULL,
  `sender` varchar(255) NOT NULL,
  `target_type` varchar(50) NOT NULL,
  `target` varchar(255) NOT NULL,
  `label` varchar(255) NOT NULL,
  `amount` int(11) NOT NULL,
  `date` date DEFAULT NULL
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=13 ;

--
-- Contenu de la table `billing`
--

INSERT INTO `billing` (`id`, `identifier`, `sender`, `target_type`, `target`, `label`, `amount`, `date`) VALUES
(12, 'society_state', 'society_state', 'society', 'society_police', '95BBU014 : +5km/h', 80, '2020-11-10');

-- --------------------------------------------------------

--
-- Structure de la table `datastore`
--

CREATE TABLE IF NOT EXISTS `datastore` (
  `name` varchar(60) NOT NULL,
  `label` varchar(255) NOT NULL,
  `shared` int(11) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Contenu de la table `datastore`
--

INSERT INTO `datastore` (`name`, `label`, `shared`) VALUES
('property', 'Propriété', 0),
('society_ambulance', 'Ambulance', 1),
('society_ammunation', 'Ammunation', 1),
('society_cluckin', 'Cluckin Bell', 1),
('society_ems', 'EMS', 1),
('society_nightclub', 'Galaxy', 1),
('society_police', 'Police', 1),
('society_state', 'State', 1),
('society_tailor', 'Couturier', 1),
('society_taxi', 'Taxi', 1),
('society_unicorn', 'Unicorn', 1),
('society_vigneron', 'Vigneron', 1);

-- --------------------------------------------------------

--
-- Structure de la table `datastore_data`
--

CREATE TABLE IF NOT EXISTS `datastore_data` (
`id` int(11) NOT NULL,
  `name` varchar(255) NOT NULL,
  `owner` varchar(255) DEFAULT NULL,
  `data` longtext
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=95 ;

--
-- Contenu de la table `datastore_data`
--

INSERT INTO `datastore_data` (`id`, `name`, `owner`, `data`) VALUES
(3, 'society_police', NULL, '{"weaponsGrasped":[{"count":0,"name":"WEAPON_FLASHLIGHT"},{"count":0,"name":"WEAPON_APPISTOL"},{"count":0,"name":"WEAPON_STICKYBOMB"},{"count":0,"name":"WEAPON_FIREWORK"},{"count":0,"name":"WEAPON_STUNGUN"},{"count":0,"name":"WEAPON_PROXMINE"},{"count":0,"name":"WEAPON_SWITCHBLADE"}],"weapons":[{"name":"WEAPON_COMBATPISTOL","count":0},{"name":"WEAPON_STUNGUN","count":2},{"name":"WEAPON_PUMPSHOTGUN","count":2},{"name":"WEAPON_ADVANCEDRIFLE","count":1},{"name":"WEAPON_APPISTOL","count":0},{"name":"WEAPON_STICKYBOMB","count":0},{"name":"WEAPON_FIREWORK","count":0},{"name":"WEAPON_PROXMINE","count":0},{"name":"WEAPON_SWITCHBLADE","count":0},{"name":"WEAPON_FLASHLIGHT","count":2},{"name":"WEAPON_BULLPUPRIFLE","count":0},{"name":"WEAPON_NIGHTSTICK","count":3},{"name":"WEAPON_HEAVYPISTOL","count":0},{"name":"WEAPON_PETROLCAN","count":2},{"name":"GADGET_PARACHUTE","count":0},{"name":"WEAPON_ASSAULTSMG","count":0},{"name":"WEAPON_SPECIALCARBINE","count":0},{"name":"WEAPON_CARBINERIFLE","count":1},{"name":"WEAPON_SMG","count":1},{"name":"WEAPON_KNUCKLE","count":0},{"name":"WEAPON_PISTOL_MK2","count":1}],"weaponsGasped":[{"count":0,"name":"WEAPON_COMBATPISTOL"},{"count":0,"name":"WEAPON_APPISTOL"},{"count":0,"name":"WEAPON_DOUBLEACTION"}]}'),
(4, 'society_ambulance', NULL, '{}'),
(5, 'society_state', NULL, '{"weapons":[{"count":1,"name":"WEAPON_STUNGUN"},{"count":0,"name":"WEAPON_NIGHTSTICK"},{"count":1,"name":"WEAPON_HEAVYPISTOL"},{"count":0,"name":"WEAPON_PUMPSHOTGUN"},{"count":0,"name":"WEAPON_ADVANCEDRIFLE"},{"count":1,"name":"WEAPON_PISTOL"}]}'),
(6, 'society_ems', NULL, '{}'),
(7, 'society_cluckin', NULL, '{}'),
(8, 'society_ammunation', NULL, '{"weapons":[{"name":"WEAPON_CARBINERIFLE","count":0},{"name":"WEAPON_MUSKET","count":1},{"name":"WEAPON_COMBATPISTOL","count":0},{"name":"WEAPON_PISTOL","count":10},{"name":"WEAPON_NIGHTSTICK","count":0},{"name":"WEAPON_PUMPSHOTGUN","count":0},{"name":"WEAPON_STUNGUN","count":0},{"name":"WEAPON_FLASHLIGHT","count":0},{"name":"WEAPON_MACHINEPISTOL","count":0},{"name":"WEAPON_ASSAULTSHOTGUN","count":0},{"name":"WEAPON_STICKYBOMB","count":0},{"name":"WEAPON_PISTOL50","count":0},{"name":"WEAPON_SNSPISTOL","count":1},{"name":"WEAPON_VINTAGEPISTOL","count":1},{"name":"WEAPON_DOUBLEACTION","count":1}]}'),
(9, 'society_nightclub', NULL, '{}'),
(10, 'society_tailor', NULL, '{}'),
(11, 'society_taxi', NULL, '{"garage":[]}'),
(12, 'society_unicorn', NULL, '{"weapons":[{"count":1,"name":"WEAPON_KNUCKLE"},{"count":0,"name":"WEAPON_SWITCHBLADE"},{"count":0,"name":"WEAPON_PISTOL"}]}'),
(13, 'society_vigneron', NULL, '{}');


-- --------------------------------------------------------

--
-- Structure de la table `dpkeybinds`
--

CREATE TABLE IF NOT EXISTS `dpkeybinds` (
  `id` varchar(50) NOT NULL,
  `keybind1` varchar(50) DEFAULT 'num4',
  `emote1` varchar(255) DEFAULT '',
  `keybind2` varchar(50) DEFAULT 'num5',
  `emote2` varchar(255) DEFAULT '',
  `keybind3` varchar(50) DEFAULT 'num6',
  `emote3` varchar(255) DEFAULT '',
  `keybind4` varchar(50) DEFAULT 'num7',
  `emote4` varchar(255) DEFAULT '',
  `keybind5` varchar(50) DEFAULT 'num8',
  `emote5` varchar(255) DEFAULT '',
  `keybind6` varchar(50) DEFAULT 'num9',
  `emote6` varchar(255) DEFAULT ''
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Structure de la table `fine_types`
--

CREATE TABLE IF NOT EXISTS `fine_types` (
`id` int(11) NOT NULL,
  `label` varchar(255) DEFAULT NULL,
  `amount` int(11) DEFAULT NULL,
  `category` int(11) DEFAULT NULL
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=45 ;

--
-- Contenu de la table `fine_types`
--

INSERT INTO `fine_types` (`id`, `label`, `amount`, `category`) VALUES
(1, 'Klaxon abusif', 50, 0),
(2, 'Non respect CDLR', 200, 0),
(3, 'Circulation hors-route', 500, 0),
(4, 'Non-respect VH prio', 750, 0),
(5, 'Entrave de la circu', 1500, 0),
(6, 'Délit de fuite', 7500, 0),
(7, 'Conduite sans permis', 20000, 0),
(8, 'Excès de vitesse 0 à 20', 150, 0),
(9, 'Excès de vitesse 20 à 40', 375, 0),
(10, 'Excès de vitesse 40 à 60', 1500, 0),
(11, 'Excès de vitesse > 60', 10000, 0),
(12, 'Retrait de permis', 10000, 0),
(13, 'Outrage citoyen', 5000, 1),
(14, 'Outrage agent', 15000, 1),
(15, 'Menace Verbale Civil', 10000, 1),
(16, 'Menace verbale agent', 15000, 1),
(17, 'Menace de mort civils', 45000, 1),
(18, 'Menace de mort agent', 75000, 1),
(19, 'Tentative de corruption', 100000, 1),
(20, 'Prise d''otage civil', 75000, 1),
(21, 'Prise d''otage agent', 125000, 1),
(22, 'Dégradation', 7500, 2),
(23, 'Trouble ordre publique', 15000, 2),
(24, 'Entrave OP police', 20000, 2),
(25, 'Escroquerie entreprise', 50000, 2),
(26, 'Pas de PPA', 35000, 3),
(27, 'Arme illégal', 75000, 3),
(28, 'Vente armes illégales', 100000, 3),
(29, 'Fab armes illégales', 100000, 3),
(30, 'Poss drogue < 100', 7500, 4),
(31, 'Poss drogue 100 à 2000', 50000, 4),
(32, 'Poss drogue > 2000', 150000, 4),
(33, 'Vente drogue', 75000, 4),
(34, 'Fabrication drogue', 125000, 4),
(35, 'Vol de véhicule', 25000, 5),
(36, 'Carjacking', 45000, 5),
(37, 'Braquage Civil', 75000, 5),
(38, 'Braquage Magasin', 75000, 5),
(39, 'Braquage Banque', 150000, 5),
(40, 'Tir sur civil ', 50000, 5),
(41, 'Tir sur agent', 80000, 5),
(42, 'Meurtre involontaire', 35000, 5),
(43, 'Meurtre sur civil', 125000, 5),
(44, 'Meurtre sur agent', 150000, 5);

-- --------------------------------------------------------

--
-- Structure de la table `inventories`
--

CREATE TABLE IF NOT EXISTS `inventories` (
  `name` varchar(50) NOT NULL,
  `label` varchar(255) NOT NULL,
  `max_weight` int(11) NOT NULL DEFAULT '100000',
  `shared` tinyint(1) NOT NULL DEFAULT '0'
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

--
-- Contenu de la table `inventories`
--

INSERT INTO `inventories` (`name`, `label`, `max_weight`, `shared`) VALUES
('gang_ballas', 'Ballas', 100000, 1),
('gang_families', 'Families', 100000, 1),
('gang_vagos', 'Vagos', 100000, 1),
('property', 'Propriété', 100000, 0),
('inventory', 'Inventaire', 20000, 0),
('society_ammunation', 'Ammunation', 100000, 1),
('society_bahama', 'Bahamas', 100000, 1),
('society_cluckin', 'Cluckin', 100000, 1),
('society_ems', 'EMS', 100000, 1),
('society_mecano', 'Mecano', 100000, 1),
('society_nightclub', 'Galaxy', 100000, 1),
('society_police', 'LSPD', 100000, 1),
('society_state', 'Gouv', 100000, 1),
('society_tailor', 'Couturier', 100000, 1),
('society_taxi', 'Taxi', 100000, 1),
('society_unicorn', 'Unicorn', 100000, 1),
('society_vigneron', 'Vigneron', 100000, 1),
('orga_celtic', 'Celtic', 100000, 1),
('orga_ordre', 'L''ordre', 100000, 1),
('biker_lost', 'The Lost', 100000, 1);

-- --------------------------------------------------------

--
-- Structure de la table `inventories_items`
--

CREATE TABLE IF NOT EXISTS `inventories_items` (
  `name` varchar(50) NOT NULL,
  `item` varchar(50) NOT NULL,
  `count` int(11) NOT NULL DEFAULT '0',
  `identifier` varchar(50) NOT NULL DEFAULT 'NULL'
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

--
-- Structure de la table `items`
--

CREATE TABLE IF NOT EXISTS `items` (
  `name` varchar(50) NOT NULL,
  `label` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin NOT NULL,
  `limit` int(11) NOT NULL DEFAULT '-1',
  `rare` int(11) NOT NULL DEFAULT '0',
  `can_remove` int(11) NOT NULL DEFAULT '1',
  `price` int(11) NOT NULL DEFAULT '0',
  `weight` int(11) NOT NULL DEFAULT '1' COMMENT 'grams'
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Contenu de la table `items`
--

INSERT INTO `items` (`name`, `label`, `limit`, `rare`, `can_remove`, `price`, `weight`) VALUES
('alive_chicken', 'Poule en cage', 20, 0, 1, 0, 4000),
('bagcoke', 'Pochon de cocaïne', 150, 0, 1, 0, 60),
('bagexta', 'Pochon d''extazy', 150, 0, 1, 0, 60),
('bagweed', 'Pochon de cannabis', 150, 0, 1, 0, 60),
('balisegps', 'balisegps', 15, 0, 1, 0, 500),
('bandage', 'Bandage', 20, 0, 1, 0, 150),
('beef', '🥩 Morceau de Boeuf', 15, 0, 1, 0, 200),
('beer', '🍺 Bière', 15, 0, 1, 0, 330),
('bread', '🥖 Pain', 15, 0, 1, 0, 100),
('cannabis', 'Cannabis', 150, 0, 1, 0, 10),
('cardboardbox', 'Boite en carton', 150, 0, 1, 0, 200),
('carokit', 'Kit carosserie', 15, 0, 1, 0, 2000),
('champagne', '🍾 Champagne', 20, 0, 1, 0, 1000),
('champagnebox', 'Caisse de Champagne', 20, 0, 1, 0, 6000),
('chickenburger', 'Chicken Burger', 20, 0, 1, 0, 400),
('chickenwrap', 'Wrap au poulet', 20, 0, 1, 0, 400),
('clip', 'Chargeur', 50, 0, 1, 0, 500),
('clothe', '👔 Vêtement', 36, 0, 1, 0, 500),
('clothebox', 'Boite de vêtements', 30, 0, 1, 0, 1500),
('cocacola', 'Canette de Coca-Cola', 15, 0, 1, 0, 330),
('coffee', '☕ Café', 15, 0, 1, 0, 150),
('coke', 'Cocaïne', 150, 0, 1, 0, 10),
('cokeleaf', 'Feuilles de Cocaïne', 150, 0, 1, 0, 10),
('copper', 'Cuivre', 100, 0, 1, 0, 500),
('cupcake', 'CupCake', 15, 0, 1, 0, 200),
('cutted_wood', 'Bois coupé', 150, 0, 1, 0, 1000),
('diamond', 'Diamant', 100, 0, 1, 0, 50),
('donut', 'Donut', 15, 0, 1, 0, 100),
('dopebag', 'Sachet hermétiques', -1, 0, 1, 0, 10),
('doublechickenburger', 'Double Chicken Burger', 20, 0, 1, 0, 600),
('extaamphetamine', 'Amphétamine', 50, 0, 1, 0, 10),
('extamdma', 'MDMA', 50, 0, 1, 0, 20),
('extazyp', 'Extazy en poudre', 250, 0, 1, 0, 10),
('fabric', '🧵 Tissu', 72, 0, 1, 0, 100),
('fixkit', '🧰 Kit réparation', 15, 0, 1, 0, 5000),
('frites', 'Frites', 20, 0, 1, 0, 200),
('gadget_parachute', 'parachute', 15, 0, 1, 0, 10000),
('gold', 'Or', 50, 0, 1, 0, 50),
('grand_cru', '🍷 Grand Cru', 20, 0, 1, 0, 1000),
('grand_crubox', 'Caisse de Grand Cru', 20, 0, 1, 0, 6000),
('gunpowder', 'Poudre à canon', 150, 0, 1, 0, 50),
('hamburger', '🍔 Hamburger', 15, 0, 1, 0, 400),
('headbag', 'Sac en tissu', 2, 0, 1, 0, 100),
('hotdog', '🌭 HotDog', 15, 0, 1, 0, 350),
('ice', 'Glaçon', 15, 0, 1, 0, 5),
('icetea', 'Ice Tea', 15, 0, 1, 0, 330),
('iron', 'Fer', 100, 0, 1, 0, 500),
('jus_raisin', 'Jus de Raisin', 20, 0, 1, 0, 330),
('jus_raisinbox', 'Caisse de Jus de raisin', 20, 0, 1, 0, 1980),
('keycoke', 'Porte clé coquelicot', 5, 0, 1, 0, 100),
('keyexta', 'Porte clé émile', 5, 0, 1, 0, 100),
('keymeth', 'Porte clé baleine', 5, 0, 1, 0, 100),
('keyweed', 'Porte clé Kiwi', 5, 0, 1, 0, 100),
('lockpick', 'Lockpick', 15, 0, 1, 0, 500),
('martini', 'Martini blanc', 15, 0, 1, 0, 100),
('martini2', 'Martini rouge', 15, 0, 1, 0, 100),
('medikit', 'Medikit', 20, 0, 1, 0, 1000),
('methacide', 'Acide Phénilacétique', 150, 0, 1, 0, 1000),
('methamphetamine', 'Pochon de Meth', 150, 0, 1, 0, 50),
('methpseudophedrine', 'Pseudophedrine', 150, 0, 1, 0, 50),
('methylamine', 'Methylamine', 150, 0, 1, 0, 50),
('mojito', 'Mojito', 15, 0, 1, 0, 330),
('nuggets', 'Boite de nuggets', 20, 0, 1, 0, 500),
('orangina', 'Orangina', 20, 0, 1, 0, 330),
('packaged_plank', 'Paquet de planches', 150, 0, 1, 0, 5000),
('pizza', 'Pizza', 15, 0, 1, 0, 800),
('plastic', 'Plastique', 150, 0, 1, 0, 50),
('plucked_chicken', 'Poulet déplumé', 20, 0, 1, 0, 3000),
('potato', 'Patate', 20, 0, 1, 0, 1000),
('potatoes', 'Potatoes', 20, 0, 1, 0, 300),
('radio', 'Radio', 5, 0, 1, 0, 500),
('raisin', 'Raisin', 180, 0, 1, 0, 300),
('raw_chicken', 'Poulet cru', 160, 0, 1, 0, 1000),
('rhum', 'Rhum', 15, 0, 1, 0, 30),
('saucisson', 'Saucisson', 15, 0, 1, 0, 400),
('sim', 'Carte SIM', 15, 0, 1, 0, 5),
('soda', 'Soda', 15, 0, 1, 0, 330),
('sprite', 'Sprite', 20, 0, 1, 0, 330),
('steel', 'Acier', 150, 0, 1, 0, 500),
('stone', 'Pierre', 150, 0, 1, 0, 1000),
('tel', 'Téléphone', 15, 0, 1, 0, 300),
('tenders', 'Tenders', 20, 0, 1, 0, 500),
('tenuecasa', 'Tenue Casa de Papel', 15, 0, 1, 0, 1500),
('tenueprison', 'Tenue de Prison', 15, 0, 1, 0, 1500),
('tequila', 'Tequila', 15, 0, 1, 0, 30),
('vine', 'Vin', 20, 0, 1, 0, 1000),
('vinebox', 'Caisse de vin', 20, 0, 1, 0, 6000),
('vodka', 'Vodka', 15, 0, 1, 0, 30),
('washed_stone', 'Pierre Lavée', 15, 0, 1, 0, 900),
('water', '💧 Bouteille d''Eau', 15, 0, 1, 0, 330),
('wateringcan', 'Eau du robinet', 15, 0, 1, 0, 500),
('weapon_advancedrifle', 'Advanced Rifle', 15, 0, 1, 0, 3000),
('weapon_appistol', 'AP Pistol', 15, 0, 1, 0, 1200),
('weapon_assaultrifle', 'AK 47', 15, 0, 1, 0, 5000),
('weapon_assaultrifle_mk2', 'assaultrifle_mk2', 15, 0, 1, 0, 5500),
('weapon_assaultshotgun', 'Shotgun', 15, 0, 1, 0, 5000),
('weapon_assaultsmg', 'SMG d''assaut', 15, 0, 1, 0, 4000),
('weapon_autoshotgun', 'Auto shotgun', 15, 0, 1, 0, 5000),
('weapon_ball', 'ball', 15, 0, 1, 0, 50),
('weapon_bat', 'Baseball Bat', 15, 0, 1, 0, 1000),
('weapon_battleaxe', 'Battle Axe', 15, 0, 1, 0, 1500),
('weapon_bottle', 'Bottle', 15, 0, 1, 0, 150),
('weapon_bullpuprifle', 'Bullpup rifle', 15, 0, 1, 0, 5000),
('weapon_bullpuprifle_mk2', 'bullpuprifle_mk2', 15, 0, 1, 0, 5500),
('weapon_bullpupshotgun', 'Bullpup shotgun', 15, 0, 1, 0, 5000),
('weapon_bzgas', 'bz gas', 15, 0, 1, 0, 300),
('weapon_carbinerifle', 'Carabine', 15, 0, 1, 0, 5000),
('weapon_carbinerifle_mk2', 'Carabine MK2', 15, 0, 1, 0, 5500),
('weapon_ceramicpistol', 'Pistolet en ceramic', 15, 0, 1, 0, 2000),
('weapon_combatmg', 'Combat mg', 15, 0, 1, 0, 10000),
('weapon_combatmg_mk2', 'combatmg_mk2', 15, 0, 1, 0, 12000),
('weapon_combatpdw', 'Combat pdw', 15, 0, 1, 0, 2500),
('weapon_combatpistol', 'Combat pistol', 15, 0, 1, 0, 1500),
('weapon_compactlauncher', 'Compact launcher', 15, 0, 1, 0, 3000),
('weapon_compactrifle', 'Compact rifle', 15, 0, 1, 0, 4000),
('weapon_crowbar', 'Crow Bar', 15, 0, 1, 0, 3000),
('weapon_dagger', 'Dagger', 15, 0, 1, 0, 1000),
('weapon_dbshotgun', 'DB shotgun', 15, 0, 1, 0, 5000),
('weapon_doubleaction', 'Double action', 15, 0, 1, 0, 1000),
('weapon_fireextinguisher', 'Fire Extinguisher', 15, 0, 1, 0, 4000),
('weapon_firework', 'Firework', 15, 0, 1, 0, 10000),
('weapon_flare', 'Flare', 15, 0, 1, 0, 300),
('weapon_flaregun', 'Flare Gun', 15, 0, 1, 0, 1000),
('weapon_flashlight', '🔦 Lampe', 15, 0, 1, 0, 500),
('weapon_golfclub', 'Golf Club', 15, 0, 1, 0, 1000),
('weapon_grenade', 'grenade', 15, 0, 1, 0, 400),
('weapon_grenadelauncher', 'Milkor MGL', 15, 0, 1, 0, 7000),
('weapon_gusenberg', 'M1928A1 Thompson SMG', 15, 0, 1, 0, 4000),
('weapon_hammer', 'Hammer', 15, 0, 1, 0, 1000),
('weapon_hatchet', 'hatchet', 15, 0, 1, 0, 1000),
('weapon_hazardcan', 'Bidon de produit chimique', 15, 0, 1, 0, 3000),
('weapon_heavypistol', 'Pistolet lourd', 15, 0, 1, 0, 1500),
('weapon_heavyshotgun', 'Heavy shotgun', 15, 0, 1, 0, 5500),
('weapon_heavysniper', 'Heavy sniper', 15, 0, 1, 0, 9000),
('weapon_heavysniper_mk2', 'heavysniper_mk2', 15, 0, 1, 0, 10000),
('weapon_hominglauncher', 'hominglauncher', 15, 0, 1, 0, 15000),
('weapon_knife', 'Knife', 15, 0, 1, 0, 500),
('weapon_knuckle', 'Poing américain', 15, 0, 1, 0, 300),
('weapon_machete', 'machete', 15, 0, 1, 0, 1000),
('weapon_machinepistol', 'Machine pistol', 15, 0, 1, 0, 3000),
('weapon_marksmanpistol', 'Marksman pistol', 15, 0, 1, 0, 2500),
('weapon_marksmanrifle', 'Marksman rifle', 15, 0, 1, 0, 8000),
('weapon_marksmanrifle_mk2', 'marksmanrifle_mk2', 15, 0, 1, 0, 9000),
('weapon_mg', 'MG', 15, 0, 1, 0, 12000),
('weapon_microsmg', 'Micro SMG', 15, 0, 1, 0, 3500),
('weapon_minigun', 'minigun', 15, 0, 1, 0, 3000),
('weapon_minismg', 'Skorpion Vz. 61', 15, 0, 1, 0, 2750),
('weapon_molotov', 'Molotov Cocktail', 15, 0, 1, 0, 800),
('weapon_musket', 'Brown Bess', 15, 0, 1, 0, 8500),
('weapon_navyrevolver', 'Revolver Navy', 15, 0, 1, 0, 2500),
('weapon_nightstick', 'ASP Baton', 15, 0, 1, 0, 300),
('weapon_petrolcan', 'Petrol Can', 15, 0, 1, 0, 1000),
('weapon_pipebomb', 'pipe bomb', 15, 0, 1, 0, 2000),
('weapon_pistol', 'Pistolet 9mm', 15, 0, 1, 0, 1100),
('weapon_pistol50', 'Desert Eagle', 15, 0, 1, 0, 2000),
('weapon_pistol_mk2', 'Pistolet MK2', 15, 0, 1, 0, 1300),
('weapon_poolcue', 'pool cue', 15, 0, 1, 0, 750),
('weapon_proxmine', 'Proxmine Mine', 15, 0, 1, 0, 1000),
('weapon_pumpshotgun', 'Pump shotgun', 15, 0, 1, 0, 5000),
('weapon_pumpshotgun_mk2', 'pumpshotgun_mk2', 15, 0, 1, 0, 6000),
('weapon_railgun', 'railgun', 15, 0, 1, 0, 10000),
('weapon_raycarbine', 'Carabine laser', 15, 0, 1, 0, 10000),
('weapon_rayminigun', 'Minigun laser', 15, 0, 1, 0, 10000),
('weapon_raypistol', 'Pistolet laser', 15, 0, 1, 0, 10000),
('weapon_revolver', 'Taurus Raging Bull', 15, 0, 1, 0, 2500),
('weapon_revolver_mk2', 'revolver_mk2', 15, 0, 1, 0, 3000),
('weapon_rpg', 'RPG-7', 15, 0, 1, 0, 12000),
('weapon_sawnoffshotgun', 'Mossberg 500', 15, 0, 1, 0, 2500),
('weapon_smg', 'MP5A3', 15, 0, 1, 0, 4000),
('weapon_smg_mk2', 'smg_mk2', 15, 0, 1, 0, 4500),
('weapon_smokegrenade', 'smoke grenade', 15, 0, 1, 0, 300),
('weapon_sniperrifle', 'Sniper', 15, 0, 1, 0, 10000),
('weapon_snowball', 'Snow Ball', 15, 0, 1, 0, 150),
('weapon_snspistol', 'SNS Pistol', 15, 0, 1, 0, 1500),
('weapon_snspistol_mk2', 'snspistol_mk2', 15, 0, 1, 0, 1750),
('weapon_specialcarbine', 'Carabine spéciale', 15, 0, 1, 0, 5000),
('weapon_specialcarbine_mk2', 'specialcarbine_mk2', 15, 0, 1, 0, 6000),
('weapon_stickybomb', 'sticky bomb', 15, 0, 1, 0, 1000),
('weapon_stungun', 'X26 Taser', 15, 0, 1, 0, 1000),
('weapon_switchblade', 'Switchblade', 15, 0, 1, 0, 550),
('weapon_vintagepistol', 'FN Model 1910', 15, 0, 1, 0, 2000),
('weapon_wrench', 'wrench', 15, 0, 1, 0, 1000),
('whisky', 'Whisky', 15, 0, 1, 0, 30),
('wood', 'Bois', 150, 0, 1, 0, 500),
('woodenbox', 'Caisse en bois', 150, 0, 1, 0, 500),
('wool', 'Laine', 180, 0, 1, 0, 200);

-- --------------------------------------------------------

--
-- Structure de la table `jobs`
--

CREATE TABLE IF NOT EXISTS `jobs` (
  `name` varchar(50) NOT NULL,
  `label` varchar(255) CHARACTER SET utf8mb4 COLLATE utf8mb4_bin DEFAULT NULL,
  `whitelisted` tinyint(1) NOT NULL DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Contenu de la table `jobs`
--

INSERT INTO `jobs` (`name`, `label`, `whitelisted`) VALUES
('ambulance', 'Ambulancier', 1),
('ammunation', 'Ammunation', 1),
('bahama', 'Bahama Mas', 1),
('ballas', 'Ballas', 1),
('cardealer', 'Concessionnaire', 1),
('cluckin', 'Cluckin Bell', 1),
('ems', 'EMS', 0),
('families', 'Families', 1),
('mecano', 'Mécano', 1),
('nightclub', 'Galaxy', 1),
('police', 'LSPD', 1),
('state', 'Gouv', 1),
('tailor', 'Couturier', 1),
('taxi', 'Taxi', 1),
('unemployed', 'Chômeur', 0),
('unemployed2', 'État', 0),
('unicorn', 'Unicorn', 1),
('vagos', 'Vagos', 1),
('vigneron', 'Vigneron', 1);

-- --------------------------------------------------------

--
-- Structure de la table `job_grades`
--

CREATE TABLE IF NOT EXISTS `job_grades` (
`id` int(11) NOT NULL,
  `job_name` varchar(255) DEFAULT NULL,
  `grade` int(11) NOT NULL,
  `name` varchar(255) NOT NULL,
  `label` varchar(255) NOT NULL,
  `salary` int(11) NOT NULL,
  `skin_male` longtext NOT NULL,
  `skin_female` longtext NOT NULL
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=374 ;

--
-- Contenu de la table `job_grades`
--

INSERT INTO `job_grades` (`id`, `job_name`, `grade`, `name`, `label`, `salary`, `skin_male`, `skin_female`) VALUES
(1, 'unemployed', 0, 'unemployed', 'Pole Emploi', 50, '{}', '{}'),
(9, 'cardealer', 0, 'recruit', 'Recrue', 1, '{}', '{}'),
(10, 'cardealer', 1, 'novice', 'Novice', 1, '{}', '{}'),
(11, 'cardealer', 2, 'experienced', 'Experimente', 1, '{}', '{}'),
(12, 'cardealer', 3, 'boss', 'Patron', 1, '{}', '{}'),
(17, 'mecano', 0, 'recrue', 'Recrue', 350, '{"tshirt_2":0,"ears_1":-1,"glasses_1":0,"torso_2":3,"ears_2":0,"glasses_2":0,"shoes_2":3,"pants_1":97,"shoes_1":7,"bags_1":0,"helmet_2":0,"pants_2":2,"torso_1":251,"tshirt_1":15,"arms":19,"bags_2":0,"helmet_1":-1}', '{"chain_1":0,"glasses_1":5,"tshirt_2":0,"shoes_2":21,"glasses_2":0,"bags_1":0,"pants_2":1,"bproof_2":0,"tshirt_1":15,"shoes_1":62,"helmet_1":-1,"torso_2":2,"helmet_2":0,"arms":63,"bproof_1":0,"torso_1":171,"pants_1":54,"bags_2":0,"chain_2":0}\r\n'),
(18, 'mecano', 1, 'novice', 'Novice', 450, '{"tshirt_2":0,"ears_1":-1,"glasses_1":0,"torso_2":3,"ears_2":0,"glasses_2":0,"shoes_2":3,"pants_1":97,"shoes_1":7,"bags_1":0,"helmet_2":0,"pants_2":2,"torso_1":251,"tshirt_1":15,"arms":19,"bags_2":0,"helmet_1":-1}', '{"chain_1":0,"glasses_1":5,"tshirt_2":0,"shoes_2":21,"glasses_2":0,"bags_1":0,"pants_2":1,"bproof_2":0,"tshirt_1":15,"shoes_1":62,"helmet_1":-1,"torso_2":2,"helmet_2":0,"arms":63,"bproof_1":0,"torso_1":171,"pants_1":54,"bags_2":0,"chain_2":0}\r\n'),
(19, 'mecano', 2, 'experimente', 'Experimente', 550, '{"tshirt_2":0,"ears_1":-1,"glasses_1":0,"torso_2":3,"ears_2":0,"glasses_2":0,"shoes_2":3,"pants_1":97,"shoes_1":7,"bags_1":0,"helmet_2":0,"pants_2":2,"torso_1":251,"tshirt_1":15,"arms":19,"bags_2":0,"helmet_1":-1}', '{"chain_1":0,"glasses_1":5,"tshirt_2":0,"shoes_2":21,"glasses_2":0,"bags_1":0,"pants_2":1,"bproof_2":0,"tshirt_1":15,"shoes_1":62,"helmet_1":-1,"torso_2":2,"helmet_2":0,"arms":63,"bproof_1":0,"torso_1":171,"pants_1":54,"bags_2":0,"chain_2":0}\r\n'),
(20, 'mecano', 3, 'chief', 'Chef d''équipe', 650, '{"tshirt_2":0,"ears_1":-1,"glasses_1":0,"torso_2":3,"ears_2":0,"glasses_2":0,"shoes_2":3,"pants_1":97,"shoes_1":7,"bags_1":0,"helmet_2":0,"pants_2":2,"torso_1":251,"tshirt_1":15,"arms":19,"bags_2":0,"helmet_1":-1}', '{"chain_1":0,"glasses_1":5,"tshirt_2":0,"shoes_2":21,"glasses_2":0,"bags_1":0,"pants_2":1,"bproof_2":0,"tshirt_1":15,"shoes_1":62,"helmet_1":-1,"torso_2":2,"helmet_2":0,"arms":63,"bproof_1":0,"torso_1":171,"pants_1":54,"bags_2":0,"chain_2":0}\r\n'),
(21, 'mecano', 4, 'boss', 'Patron', 850, '{"tshirt_2":0,"ears_1":-1,"glasses_1":0,"torso_2":3,"ears_2":0,"glasses_2":0,"shoes_2":3,"pants_1":97,"shoes_1":7,"bags_1":0,"helmet_2":0,"pants_2":2,"torso_1":251,"tshirt_1":15,"arms":19,"bags_2":0,"helmet_1":-1}', '{"chain_1":0,"glasses_1":5,"tshirt_2":0,"shoes_2":21,"glasses_2":0,"bags_1":0,"pants_2":1,"bproof_2":0,"tshirt_1":15,"shoes_1":62,"helmet_1":-1,"torso_2":2,"helmet_2":0,"arms":63,"bproof_1":0,"torso_1":171,"pants_1":54,"bags_2":0,"chain_2":0}\r\n'),
(30, 'taxi', 0, 'recrue', 'CDD', 100, '{"tshirt_1":15,"tshirt_2":0,"torso_1":12,"torso_2":0,"pants_1":0,"pants_2":1,"shoes_1":32,"shoes_2":0,"chain_1":0,"chain_2":0,"bags_1":0,"bags_2":0,"bproof_1":0,"bproof_2":0,"helmet_1":-1,"helmet_2":0,"arms":20,"glasses_1":0,"glasses_2":0}', '{"chain_1":0,"glasses_1":11,"tshirt_2":0,"shoes_2":0,"glasses_2":3,"bags_1":0,"pants_2":12,"bproof_2":0,"tshirt_1":64,"shoes_1":13,"helmet_1":-1,"torso_2":0,"helmet_2":0,"arms":23,"bproof_1":0,"torso_1":7,"pants_1":23,"bags_2":0,"chain_2":0}\r\n'),
(31, 'taxi', 1, 'novice', 'Employé', 200, '{"tshirt_1":15,"tshirt_2":0,"torso_1":12,"torso_2":0,"pants_1":0,"pants_2":1,"shoes_1":32,"shoes_2":0,"chain_1":0,"chain_2":0,"bags_1":0,"bags_2":0,"bproof_1":0,"bproof_2":0,"helmet_1":-1,"helmet_2":0,"arms":20,"glasses_1":0,"glasses_2":0}', '{"chain_1":0,"glasses_1":11,"tshirt_2":0,"shoes_2":0,"glasses_2":3,"bags_1":0,"pants_2":12,"bproof_2":0,"tshirt_1":64,"shoes_1":13,"helmet_1":-1,"torso_2":0,"helmet_2":0,"arms":23,"bproof_1":0,"torso_1":7,"pants_1":23,"bags_2":0,"chain_2":0}\r\n'),
(32, 'taxi', 2, 'experimente', 'Responsable', 300, '{"tshirt_1":15,"tshirt_2":0,"torso_1":12,"torso_2":0,"pants_1":0,"pants_2":1,"shoes_1":32,"shoes_2":0,"chain_1":0,"chain_2":0,"bags_1":0,"bags_2":0,"bproof_1":0,"bproof_2":0,"helmet_1":-1,"helmet_2":0,"arms":20,"glasses_1":0,"glasses_2":0}', '{"chain_1":0,"glasses_1":11,"tshirt_2":0,"shoes_2":0,"glasses_2":3,"bags_1":0,"pants_2":12,"bproof_2":0,"tshirt_1":64,"shoes_1":13,"helmet_1":-1,"torso_2":0,"helmet_2":0,"arms":23,"bproof_1":0,"torso_1":7,"pants_1":23,"bags_2":0,"chain_2":0}\r\n'),
(33, 'taxi', 3, 'uber', 'Cadre', 400, '{"tshirt_1":15,"tshirt_2":0,"torso_1":12,"torso_2":0,"pants_1":0,"pants_2":1,"shoes_1":32,"shoes_2":0,"chain_1":0,"chain_2":0,"bags_1":0,"bags_2":0,"bproof_1":0,"bproof_2":0,"helmet_1":-1,"helmet_2":0,"arms":20,"glasses_1":0,"glasses_2":0}', '{"chain_1":0,"glasses_1":11,"tshirt_2":0,"shoes_2":0,"glasses_2":3,"bags_1":0,"pants_2":12,"bproof_2":0,"tshirt_1":64,"shoes_1":13,"helmet_1":-1,"torso_2":0,"helmet_2":0,"arms":23,"bproof_1":0,"torso_1":7,"pants_1":23,"bags_2":0,"chain_2":0}\r\n'),
(34, 'taxi', 4, 'boss', 'Patron', 0, '{"tshirt_1":32,"tshirt_2":0,"torso_1":29,"torso_2":0,"pants_1":0,"pants_2":1,"shoes_1":32,"shoes_2":0,"chain_1":0,"chain_2":0,"bags_1":0,"bags_2":0,"bproof_1":0,"bproof_2":0,"helmet_1":-1,"helmet_2":0,"arms":22,"glasses_1":0,"glasses_2":0}', '{"chain_1":0,"glasses_1":11,"tshirt_2":0,"shoes_2":0,"glasses_2":3,"bags_1":0,"pants_2":12,"bproof_2":0,"tshirt_1":64,"shoes_1":13,"helmet_1":-1,"torso_2":0,"helmet_2":0,"arms":23,"bproof_1":0,"torso_1":7,"pants_1":23,"bags_2":0,"chain_2":0}\r\n'),
(123, 'police', 0, 'recruit', 'Cadet', 150, '{}', '{}'),
(124, 'police', 1, 'officer', 'Officier', 300, '{}', '{}'),
(125, 'police', 2, 'sergeant', 'Sergent', 450, '{}', '{}'),
(126, 'police', 3, 'intendent', 'Sergent-Chef', 600, '{}', '{}'),
(127, 'police', 4, 'lieutenant', 'Lieutenant', 750, '{}', '{}'),
(128, 'police', 5, 'chef', 'Capitaine', 900, '{}', '{}'),
(129, 'police', 6, 'boss', 'Commandant', 999, '{}', '{}'),
(130, 'police', 7, 'bac', 'BAC', 700, '{}', '{}'),
(236, 'families', 0, 'soldato', 'Petite frappe', 0, '{}', '{}'),
(238, 'families', 1, 'consigliere', 'Caporal Chef', 0, '{}', '{}'),
(239, 'families', 2, 'righthand', 'Bras Droit', 0, '{}', '{}'),
(240, 'families', 3, 'gboss', 'Chef', 0, '', '{}'),
(256, 'unemployed2', 0, 'rsa', 'Civil', 80, '{}', '{}'),
(263, 'state', 0, 'protec', 'Protection rapprochée', 100, '{"tshirt_1":96,"tshirt_2":16,"torso_1":31,"torso_2":0,"pants_1":24,"pants_2":0,"shoes_1":21,"shoes_2":0,"chain_1":28,"chain_2":15,"bags_1":0,"bags_2":0,"bproof_1":0,"bproof_2":0,"helmet_1":-1,"helmet_2":0,"arms":22,"glasses_1":0,"glasses_2":0,"mask_1":121,"mask_2":0}', '{"chain_1":0,"glasses_1":5,"tshirt_2":0,"shoes_2":2,"glasses_2":0,"bags_1":0,"pants_2":0,"bproof_2":0,"tshirt_1":38,"shoes_1":42,"helmet_1":-1,"torso_2":0,"helmet_2":0,"arms":3,"bproof_1":0,"torso_1":24,"pants_1":7,"bags_2":0,"chain_2":0}\r\n'),
(265, 'state', 1, 'proc', 'Procureur', 200, '{"tshirt_1":31,"tshirt_2":0,"torso_1":10,"torso_2":0,"pants_1":35,"pants_2":0,"shoes_1":10,"shoes_2":0,"chain_1":0,"chain_2":0,"bags_1":0,"bags_2":0,"bproof_1":0,"bproof_2":0,"helmet_1":-1,"helmet_2":0,"arms":4,"glasses_1":0,"glasses_2":1}', '{"chain_1":0,"glasses_1":5,"tshirt_2":0,"shoes_2":2,"glasses_2":0,"bags_1":0,"pants_2":0,"bproof_2":0,"tshirt_1":38,"shoes_1":42,"helmet_1":-1,"torso_2":0,"helmet_2":0,"arms":3,"bproof_1":0,"torso_1":24,"pants_1":7,"bags_2":0,"chain_2":0}\r\n'),
(266, 'state', 2, 'boss', 'Gouverneur', 300, '{"tshirt_1":31,"tshirt_2":0,"torso_1":10,"torso_2":0,"pants_1":35,"pants_2":0,"shoes_1":10,"shoes_2":0,"chain_1":10,"chain_2":1,"bags_1":0,"bags_2":0,"bproof_1":0,"bproof_2":0,"helmet_1":-1,"helmet_2":0,"arms":4,"glasses_1":0,"glasses_2":1}', '{"chain_1":0,"glasses_1":5,"tshirt_2":0,"shoes_2":2,"glasses_2":0,"bags_1":0,"pants_2":0,"bproof_2":0,"tshirt_1":38,"shoes_1":42,"helmet_1":-1,"torso_2":0,"helmet_2":0,"arms":3,"bproof_1":0,"torso_1":24,"pants_1":7,"bags_2":0,"chain_2":0}\r\n'),
(321, 'vagos', 0, 'soldato', 'Hermano', 0, '{}', '{}'),
(322, 'vagos', 1, 'capo', 'Gringo', 0, '{}', '{}'),
(323, 'vagos', 2, 'consigliere', 'Secondo', 0, '{}', '{}'),
(324, 'vagos', 3, 'gboss', 'Jéfé', 0, '{}', '{}'),
(325, 'ballas', 0, 'soldato', 'Homie', 0, '{}', '{}'),
(326, 'ballas', 1, 'capo', 'Soldier', 0, '{}', '{}'),
(327, 'ballas', 2, 'consigliere', 'Hustler', 0, '{}', '{}'),
(328, 'ballas', 3, 'gboss', 'Chef', 0, '{}', '{}'),
(346, 'ambulance', 0, 'ambulance', 'Infirmier', 300, '{"pants_2":2,"bproof_1":0,"bproof_2":0,"helmet_1":122,"bags_1":0,"chain_2":0,"shoes_1":42,"arms":90,"glasses_1":0,"bags_2":0,"glasses_2":0,"torso_2":0,"tshirt_1":15,"chain_1":126,"helmet_2":0,"shoes_2":2,"pants_1":48,"tshirt_2":0,"torso_1":249}', '{"pants_2":2,"bproof_1":0,"bproof_2":0,"helmet_1":122,"bags_1":0,"chain_2":0,"shoes_1":42,"arms":90,"glasses_1":0,"bags_2":0,"glasses_2":0,"torso_2":0,"tshirt_1":15,"chain_1":126,"helmet_2":0,"shoes_2":2,"pants_1":48,"tshirt_2":0,"torso_1":249}'),
(347, 'ambulance', 1, 'doctor', 'Médecin', 400, '{"pants_2":2,"bproof_1":0,"bproof_2":0,"helmet_1":122,"bags_1":0,"chain_2":0,"shoes_1":42,"arms":90,"glasses_1":0,"bags_2":0,"glasses_2":0,"torso_2":0,"tshirt_1":15,"chain_1":126,"helmet_2":0,"shoes_2":2,"pants_1":48,"tshirt_2":0,"torso_1":249}', '{"pants_2":2,"bproof_1":0,"bproof_2":0,"helmet_1":122,"bags_1":0,"chain_2":0,"shoes_1":42,"arms":90,"glasses_1":0,"bags_2":0,"glasses_2":0,"torso_2":0,"tshirt_1":15,"chain_1":126,"helmet_2":0,"shoes_2":2,"pants_1":48,"tshirt_2":0,"torso_1":249}'),
(348, 'ambulance', 2, 'boss', 'Directeur', 500, '{"pants_2":2,"bproof_1":0,"bproof_2":0,"helmet_1":122,"bags_1":0,"chain_2":0,"shoes_1":42,"arms":90,"glasses_1":0,"bags_2":0,"glasses_2":0,"torso_2":0,"tshirt_1":15,"chain_1":126,"helmet_2":0,"shoes_2":2,"pants_1":48,"tshirt_2":0,"torso_1":249}', '{"pants_2":2,"bproof_1":0,"bproof_2":0,"helmet_1":122,"bags_1":0,"chain_2":0,"shoes_1":42,"arms":90,"glasses_1":0,"bags_2":0,"glasses_2":0,"torso_2":0,"tshirt_1":15,"chain_1":126,"helmet_2":0,"shoes_2":2,"pants_1":48,"tshirt_2":0,"torso_1":249}'),
(349, 'vigneron', 0, 'interim', 'Intérimaire', 50, '{"tshirt_1":59,"tshirt_2":0,"torso_1":12,"torso_2":5,"shoes_1":7,"shoes_2":2,"pants_1":9, "pants_2":7, "arms":1, "helmet_1":11, "helmet_2":0,"bags_1":0,"bags_2":0,"ears_1":0,"glasses_1":0,"ears_2":0,"glasses_2":0}', '{"chain_1":0,"glasses_1":5,"tshirt_2":0,"shoes_2":3,"glasses_2":0,"bags_1":0,"bproof_2":0,"tshirt_1":4,"helmet_1":54,"torso_2":12,"helmet_2":2,"arms":79,"bproof_1":0,"pants_2":1,"torso_1":354,"pants_1":54,"bags_2":0,"chain_2":0,"shoes_1":11}\r\n'),
(350, 'vigneron', 1, 'employe', 'Employé', 200, '{"tshirt_1":57,"tshirt_2":0,"torso_1":13,"torso_2":5,"shoes_1":7,"shoes_2":2,"pants_1":9, "pants_2":7, "arms":11, "helmet_1":11, "helmet_2":0,"bags_1":0,"bags_2":0,"ears_1":0,"glasses_1":0,"ears_2":0,"glasses_2":0}', '{"chain_1":0,"glasses_1":5,"tshirt_2":0,"shoes_2":3,"glasses_2":0,"bags_1":0,"bproof_2":0,"tshirt_1":4,"helmet_1":54,"torso_2":12,"helmet_2":2,"arms":79,"bproof_1":0,"pants_2":1,"torso_1":354,"pants_1":54,"bags_2":0,"chain_2":0,"shoes_1":11}\r\n'),
(351, 'vigneron', 2, 'chef', 'Chef', 400, '{"tshirt_1":57,"tshirt_2":0,"torso_1":13,"torso_2":5,"shoes_1":7,"shoes_2":2,"pants_1":9, "pants_2":7, "arms":11, "helmet_1":11, "helmet_2":0,"bags_1":0,"bags_2":0,"ears_1":0,"glasses_1":0,"ears_2":0,"glasses_2":0}', '{"chain_1":0,"glasses_1":5,"tshirt_2":0,"shoes_2":3,"glasses_2":0,"bags_1":0,"bproof_2":0,"tshirt_1":4,"helmet_1":54,"torso_2":12,"helmet_2":2,"arms":79,"bproof_1":0,"pants_2":1,"torso_1":354,"pants_1":54,"bags_2":0,"chain_2":0,"shoes_1":11}\r\n'),
(352, 'vigneron', 3, 'boss', 'Patron', 500, '{"tshirt_1":57,"tshirt_2":0,"torso_1":13,"torso_2":5,"shoes_1":7,"shoes_2":2,"pants_1":9, "pants_2":7, "arms":11, "helmet_1":11, "helmet_2":0,"bags_1":0,"bags_2":0,"ears_1":0,"glasses_1":0,"ears_2":0,"glasses_2":0}', '{"chain_1":0,"glasses_1":5,"tshirt_2":0,"shoes_2":3,"glasses_2":0,"bags_1":0,"bproof_2":0,"tshirt_1":4,"helmet_1":54,"torso_2":12,"helmet_2":2,"arms":79,"bproof_1":0,"pants_2":1,"torso_1":354,"pants_1":54,"bags_2":0,"chain_2":0,"shoes_1":11}\r\n'),
(353, 'tailor', 0, 'interim', 'Intérimaire', 50, '{"tshirt_1":59,"tshirt_2":0,"torso_1":12,"torso_2":5,"shoes_1":7,"shoes_2":2,"pants_1":9, "pants_2":7, "arms":1, "helmet_1":11, "helmet_2":0,"bags_1":0,"bags_2":0,"ears_1":0,"glasses_1":0,"ears_2":0,"glasses_2":0}', '{"tshirt_1":0,"tshirt_2":0,"torso_1":56,"torso_2":0,"shoes_1":27,"shoes_2":0,"pants_1":36, "pants_2":0, "arms":63, "helmet_1":11, "helmet_2":0,"bags_1":0,"bags_2":0,"ears_1":0,"glasses_1":0,"ears_2":0,"glasses_2":0}'),
(354, 'tailor', 1, 'employe', 'Employé', 200, '{"tshirt_1":57,"tshirt_2":0,"torso_1":13,"torso_2":5,"shoes_1":7,"shoes_2":2,"pants_1":9, "pants_2":7, "arms":11, "helmet_1":11, "helmet_2":0,"bags_1":0,"bags_2":0,"ears_1":0,"glasses_1":0,"ears_2":0,"glasses_2":0}', '{"tshirt_1":0,"tshirt_2":0,"torso_1":56,"torso_2":0,"shoes_1":27,"shoes_2":0,"pants_1":36, "pants_2":0, "arms":63, "helmet_1":11, "helmet_2":0,"bags_1":0,"bags_2":0,"ears_1":0,"glasses_1":0,"ears_2":0,"glasses_2":0}'),
(355, 'tailor', 2, 'chef', 'Chef', 400, '{"tshirt_1":57,"tshirt_2":0,"torso_1":13,"torso_2":5,"shoes_1":7,"shoes_2":2,"pants_1":9, "pants_2":7, "arms":11, "helmet_1":11, "helmet_2":0,"bags_1":0,"bags_2":0,"ears_1":0,"glasses_1":0,"ears_2":0,"glasses_2":0}', '{"tshirt_1":0,"tshirt_2":0,"torso_1":56,"torso_2":0,"shoes_1":27,"shoes_2":0,"pants_1":36, "pants_2":0, "arms":63, "helmet_1":11, "helmet_2":0,"bags_1":0,"bags_2":0,"ears_1":0,"glasses_1":0,"ears_2":0,"glasses_2":0}'),
(356, 'tailor', 3, 'boss', 'Patron', 500, '{"tshirt_1":57,"tshirt_2":0,"torso_1":13,"torso_2":5,"shoes_1":7,"shoes_2":2,"pants_1":9, "pants_2":7, "arms":11, "helmet_1":11, "helmet_2":0,"bags_1":0,"bags_2":0,"ears_1":0,"glasses_1":0,"ears_2":0,"glasses_2":0}', '{"tshirt_1":15,"tshirt_2":0,"torso_1":14,"torso_2":15,"shoes_1":12,"shoes_2":0,"pants_1":9, "pants_2":5, "arms":1, "helmet_1":11, "helmet_2":0,"bags_1":0,"bags_2":0,"ears_1":0,"glasses_1":0,"ears_2":0,"glasses_2":0}'),
(357, 'cluckin', 0, 'employe', 'Employé', 300, '{"chain_2":0,"bproof_2":0,"bproof_1":0,"glasses_2":0,"bags_1":0,"chain_1":19,"arms":11,"pants_1":27,"helmet_1":130,"shoes_2":0,"glasses_1":0,"bags_2":0,"pants_2":1,"tshirt_1":87,"helmet_2":5,"tshirt_2":0,"torso_1":13,"shoes_1":49,"torso_2":8}\r\n', '{"chain_1":0,"glasses_1":5,"tshirt_2":0,"shoes_2":11,"glasses_2":0,"bags_1":0,"pants_2":12,"bproof_2":0,"tshirt_1":15,"shoes_1":13,"helmet_1":129,"torso_2":10,"helmet_2":5,"arms":1,"bproof_1":0,"torso_1":294,"pants_1":12,"bags_2":0,"chain_2":0}\r\n'),
(358, 'cluckin', 1, 'chef', 'Chef', 400, '{"chain_2":0,"bproof_2":0,"bproof_1":0,"glasses_2":0,"bags_1":0,"chain_1":19,"arms":11,"pants_1":27,"helmet_1":130,"shoes_2":0,"glasses_1":0,"bags_2":0,"pants_2":1,"tshirt_1":87,"helmet_2":5,"tshirt_2":0,"torso_1":13,"shoes_1":49,"torso_2":8}\r\n', '{"chain_1":0,"glasses_1":5,"tshirt_2":0,"shoes_2":11,"glasses_2":0,"bags_1":0,"pants_2":12,"bproof_2":0,"tshirt_1":15,"shoes_1":13,"helmet_1":129,"torso_2":10,"helmet_2":5,"arms":1,"bproof_1":0,"torso_1":294,"pants_1":12,"bags_2":0,"chain_2":0}\r\n'),
(359, 'cluckin', 2, 'boss', 'Patron', 700, '{"chain_2":0,"bproof_2":0,"bproof_1":0,"glasses_2":0,"bags_1":0,"chain_1":19,"arms":11,"pants_1":27,"helmet_1":130,"shoes_2":0,"glasses_1":0,"bags_2":0,"pants_2":1,"tshirt_1":87,"helmet_2":5,"tshirt_2":0,"torso_1":13,"shoes_1":49,"torso_2":8}\r\n', '{"chain_1":0,"glasses_1":5,"tshirt_2":0,"shoes_2":11,"glasses_2":0,"bags_1":0,"pants_2":12,"bproof_2":0,"tshirt_1":15,"shoes_1":13,"helmet_1":129,"torso_2":10,"helmet_2":5,"arms":1,"bproof_1":0,"torso_1":294,"pants_1":12,"bags_2":0,"chain_2":0}\r\n'),
(360, 'unicorn', 0, 'employe', 'Employe', 200, '{}', '{}'),
(361, 'unicorn', 1, 'boss', 'Patron', 500, '{}', '{}'),
(362, 'bahama', 0, 'employe', 'Employe', 200, '{}', '{}'),
(363, 'bahama', 1, 'boss', 'Patron', 500, '{}', '{}'),
(364, 'nightclub', 0, 'employe', 'Employe', 200, '{}', '{}'),
(365, 'nightclub', 1, 'boss', 'Patron', 500, '{}', '{}'),
(366, 'ammunation', 0, 'employe', 'Employé', 200, '{"tshirt_1":57,"tshirt_2":0,"torso_1":13,"torso_2":5,"shoes_1":7,"shoes_2":2,"pants_1":9, "pants_2":7, "arms":11, "helmet_1":11, "helmet_2":0,"bags_1":0,"bags_2":0,"ears_1":0,"glasses_1":0,"ears_2":0,"glasses_2":0}', '{"chain_1":0,"glasses_1":11,"tshirt_2":9,"shoes_2":1,"glasses_2":3,"bags_1":0,"pants_2":8,"bproof_2":0,"tshirt_1":206,"shoes_1":22,"helmet_1":-1,"torso_2":3,"helmet_2":0,"arms":4,"bproof_1":0,"torso_1":194,"pants_1":87,"bags_2":0,"chain_2":0}\r\n'),
(367, 'ammunation', 1, 'boss', 'Patron', 500, '{"tshirt_1":57,"tshirt_2":0,"torso_1":13,"torso_2":5,"shoes_1":7,"shoes_2":2,"pants_1":9, "pants_2":7, "arms":11, "helmet_1":11, "helmet_2":0,"bags_1":0,"bags_2":0,"ears_1":0,"glasses_1":0,"ears_2":0,"glasses_2":0}', '{"chain_1":0,"glasses_1":11,"tshirt_2":9,"shoes_2":1,"glasses_2":3,"bags_1":0,"pants_2":8,"bproof_2":0,"tshirt_1":206,"shoes_1":22,"helmet_1":-1,"torso_2":3,"helmet_2":0,"arms":4,"bproof_1":0,"torso_1":194,"pants_1":87,"bags_2":0,"chain_2":0}\r\n'),
(371, 'ems', 0, 'employee', 'Ambulancier', 20, '{"pants_2":2,"bproof_1":0,"bproof_2":0,"helmet_1":122,"bags_1":0,"chain_2":0,"shoes_1":42,"arms":90,"glasses_1":0,"bags_2":0,"glasses_2":0,"torso_2":0,"tshirt_1":15,"chain_1":126,"helmet_2":0,"shoes_2":2,"pants_1":48,"tshirt_2":0,"torso_1":249}', '{"chain_1":96,"glasses_1":5,"tshirt_2":0,"shoes_2":22,"glasses_2":0,"bags_1":0,"pants_2":0,"bproof_2":0,"helmet_1":-1,"tshirt_1":15,"torso_2":0,"helmet_2":0,"arms":109,"bproof_1":0,"shoes_1":62,"torso_1":258,"pants_1":23,"bags_2":0,"chain_2":0}'),
(372, 'ems', 1, 'doctor', 'Medecin', 40, '{"pants_2":2,"bproof_1":0,"bproof_2":0,"helmet_1":122,"bags_1":0,"chain_2":0,"shoes_1":42,"arms":90,"glasses_1":0,"bags_2":0,"glasses_2":0,"torso_2":0,"tshirt_1":15,"chain_1":126,"helmet_2":0,"shoes_2":2,"pants_1":48,"tshirt_2":0,"torso_1":249}', '{"chain_1":96,"glasses_1":5,"tshirt_2":0,"shoes_2":22,"glasses_2":0,"bags_1":0,"pants_2":0,"bproof_2":0,"helmet_1":-1,"tshirt_1":15,"torso_2":0,"helmet_2":0,"arms":109,"bproof_1":0,"shoes_1":62,"torso_1":258,"pants_1":23,"bags_2":0,"chain_2":0}'),
(373, 'ems', 2, 'boss', 'Directeur', 80, '{"pants_2":2,"bproof_1":0,"bproof_2":0,"helmet_1":122,"bags_1":0,"chain_2":0,"shoes_1":42,"arms":90,"glasses_1":0,"bags_2":0,"glasses_2":0,"torso_2":0,"tshirt_1":15,"chain_1":126,"helmet_2":0,"shoes_2":2,"pants_1":48,"tshirt_2":0,"torso_1":249}', '{"chain_1":96,"glasses_1":5,"tshirt_2":0,"shoes_2":22,"glasses_2":0,"bags_1":0,"pants_2":0,"bproof_2":0,"helmet_1":-1,"tshirt_1":15,"torso_2":0,"helmet_2":0,"arms":109,"bproof_1":0,"shoes_1":62,"torso_1":258,"pants_1":23,"bags_2":0,"chain_2":0}');

-- --------------------------------------------------------

--
-- Structure de la table `licenses`
--

CREATE TABLE IF NOT EXISTS `licenses` (
  `type` varchar(60) NOT NULL,
  `label` varchar(60) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Contenu de la table `licenses`
--

INSERT INTO `licenses` (`type`, `label`) VALUES
('dmv', 'Code de la route'),
('drive', 'Permis de conduire'),
('drive_bike', 'Permis moto'),
('drive_truck', 'Permis camion'),
('weapon', 'PPA'),
('weapon2', 'Permit de Port d''Armes Lourdes');

-- --------------------------------------------------------

--
-- Structure de la table `open_car`
--

CREATE TABLE IF NOT EXISTS `open_car` (
`id` int(11) NOT NULL,
  `identifier` varchar(255) DEFAULT NULL,
  `label` varchar(255) DEFAULT NULL,
  `value` varchar(50) DEFAULT NULL,
  `got` varchar(50) DEFAULT NULL,
  `NB` int(11) DEFAULT '0' COMMENT '1 possède, 2 double'
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=360 ;

-- --------------------------------------------------------

--
-- Structure de la table `owned_keys`
--

CREATE TABLE IF NOT EXISTS `owned_keys` (
`id` int(11) NOT NULL,
  `identifier` varchar(50) NOT NULL,
  `plate` varchar(12) NOT NULL,
  `type` int(1) NOT NULL
) ENGINE=MyISAM  DEFAULT CHARSET=latin1 AUTO_INCREMENT=32 ;

-- --------------------------------------------------------

--
-- Structure de la table `owned_properties`
--

CREATE TABLE IF NOT EXISTS `owned_properties` (
`id` int(11) NOT NULL,
  `name` varchar(255) NOT NULL,
  `price` double NOT NULL,
  `rented` int(11) NOT NULL,
  `owner` varchar(60) NOT NULL
) ENGINE=MyISAM  DEFAULT CHARSET=latin1 AUTO_INCREMENT=75 ;

-- --------------------------------------------------------

--
-- Structure de la table `owned_vehicles`
--

CREATE TABLE IF NOT EXISTS `owned_vehicles` (
  `owner` varchar(22) NOT NULL,
  `plate` varchar(12) NOT NULL,
  `location` varchar(50) NOT NULL DEFAULT 'garage_POUND',
  `vehicle` longtext,
  `fuel` decimal(6,3) NOT NULL DEFAULT '100.000',
  `type` varchar(20) NOT NULL DEFAULT 'car'
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Structure de la table `phone_app_chat`
--

CREATE TABLE IF NOT EXISTS `phone_app_chat` (
`id` int(11) NOT NULL,
  `channel` varchar(20) NOT NULL,
  `message` varchar(255) NOT NULL,
  `time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=5 ;

--
-- Contenu de la table `phone_app_chat`
--

INSERT INTO `phone_app_chat` (`id`, `channel`, `message`, `time`) VALUES
(1, 'weedman', 'yo', '2020-08-21 22:30:35'),
(2, 'test', 'test', '2020-08-26 21:52:32'),
(3, 'test', 'qzdqzd', '2020-08-26 21:52:36'),
(4, 'test', 'dgegg', '2020-08-26 21:52:38');

-- --------------------------------------------------------

--
-- Structure de la table `phone_calls`
--

CREATE TABLE IF NOT EXISTS `phone_calls` (
`id` int(11) NOT NULL,
  `owner` varchar(10) NOT NULL COMMENT 'Num tel proprio',
  `num` varchar(10) NOT NULL COMMENT 'Num reférence du contact',
  `incoming` int(11) NOT NULL COMMENT 'Défini si on est à l''origine de l''appels',
  `time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `accepts` int(11) NOT NULL COMMENT 'Appels accepter ou pas'
) ENGINE=InnoDB  DEFAULT CHARSET=utf8 AUTO_INCREMENT=101 ;

-- --------------------------------------------------------

--
-- Structure de la table `phone_messages`
--

CREATE TABLE IF NOT EXISTS `phone_messages` (
`id` int(11) NOT NULL,
  `transmitter` varchar(10) NOT NULL,
  `receiver` varchar(10) NOT NULL,
  `message` varchar(255) NOT NULL DEFAULT '0',
  `time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `isRead` int(11) NOT NULL DEFAULT '0',
  `owner` int(11) NOT NULL DEFAULT '0'
) ENGINE=MyISAM  DEFAULT CHARSET=utf8 AUTO_INCREMENT=11498 ;

--
-- Contenu de la table `phone_messages`
--

-- --------------------------------------------------------

--
-- Structure de la table `phone_users_contacts`
--

CREATE TABLE IF NOT EXISTS `phone_users_contacts` (
`id` int(11) NOT NULL,
  `identifier` varchar(60) DEFAULT NULL,
  `number` varchar(10) DEFAULT NULL,
  `display` varchar(64) NOT NULL DEFAULT '-1'
) ENGINE=MyISAM  DEFAULT CHARSET=utf8 AUTO_INCREMENT=382 ;

-- --------------------------------------------------------

--
-- Structure de la table `playerstattoos`
--

CREATE TABLE IF NOT EXISTS `playerstattoos` (
`id` int(11) NOT NULL,
  `identifier` varchar(255) NOT NULL,
  `tattoos` text NOT NULL
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=196 ;

-- --------------------------------------------------------

--
-- Structure de la table `properties`
--

CREATE TABLE IF NOT EXISTS `properties` (
`id` int(11) NOT NULL,
  `name` varchar(255) DEFAULT NULL,
  `label` varchar(255) DEFAULT NULL,
  `entering` varchar(255) DEFAULT NULL,
  `exit` varchar(255) DEFAULT NULL,
  `inside` varchar(255) DEFAULT NULL,
  `outside` varchar(255) DEFAULT NULL,
  `ipls` varchar(255) DEFAULT '[]',
  `gateway` varchar(255) DEFAULT NULL,
  `is_single` int(11) DEFAULT NULL,
  `is_room` int(11) DEFAULT NULL,
  `is_gateway` int(11) DEFAULT NULL,
  `room_menu` varchar(255) DEFAULT NULL,
  `price` int(11) NOT NULL
) ENGINE=MyISAM  DEFAULT CHARSET=latin1 AUTO_INCREMENT=537 ;

--
-- Contenu de la table `properties`
--

INSERT INTO `properties` (`id`, `name`, `label`, `entering`, `exit`, `inside`, `outside`, `ipls`, `gateway`, `is_single`, `is_room`, `is_gateway`, `room_menu`, `price`) VALUES
(36, 'Aqua3Apartment', 'Appartement Aqua 3', NULL, '{"x":-774.012,"y":342.042,"z":195.686}', '{"x":-779.057,"y":342.063,"z":195.686}', NULL, '["apa_v_mp_h_08_b"]', 'MiltonDrive', 0, 1, 0, '{"x":-765.287,"y":331.084,"z":195.086}', 1300000),
(37, 'IntegrityWay', '4 Integrity Way', '{"x":-47.804,"y":-585.867,"z":36.956}', NULL, NULL, '{"x":-54.178,"y":-583.762,"z":35.798}', '[]', NULL, 0, 0, 1, NULL, 0),
(35, 'Aqua2Apartment', 'Appartement Aqua 2', NULL, '{"x":-786.8663,"y":315.764,"z":186.913}', '{"x":-781.808,"y":315.866,"z":186.913}', NULL, '["apa_v_mp_h_08_c"]', 'MiltonDrive', 0, 1, 0, '{"x":-795.658,"y":326.563,"z":186.313}', 1300000),
(34, 'Aqua1Apartment', 'Appartement Aqua 1', NULL, '{"x":-784.194,"y":323.636,"z":210.997}', '{"x":-779.751,"y":323.385,"z":210.997}', NULL, '["apa_v_mp_h_08_a"]', 'MiltonDrive', 0, 1, 0, '{"x":-766.187,"y":328.47,"z":210.396}', 1300000),
(33, 'Regal3Apartment', 'Appartement Régal 3', NULL, '{"x":-774.012,"y":342.042,"z":195.686}', '{"x":-779.057,"y":342.063,"z":195.686}', NULL, '["apa_v_mp_h_07_b"]', 'MiltonDrive', 0, 1, 0, '{"x":-765.087,"y":331.429,"z":195.123}', 1300000),
(32, 'Regal2Apartment', 'Appartement Régal 2', NULL, '{"x":-786.8663,"y":315.764,"z":186.913}', '{"x":-781.808,"y":315.866,"z":186.913}', NULL, '["apa_v_mp_h_07_c"]', 'MiltonDrive', 0, 1, 0, '{"x":-795.545,"y":326.659,"z":186.313}', 1300000),
(31, 'Regal1Apartment', 'Appartement Régal 1', NULL, '{"x":-784.194,"y":323.636,"z":210.997}', '{"x":-779.751,"y":323.385,"z":210.997}', NULL, '["apa_v_mp_h_07_a"]', 'MiltonDrive', 0, 1, 0, '{"x":-765.956,"y":328.257,"z":210.396}', 1300000),
(30, 'Seductive3Apartment', 'Appartement Séduisant 3', NULL, '{"x":-774.012,"y":342.042,"z":195.686}', '{"x":-779.057,"y":342.063,"z":195.686}', NULL, '["apa_v_mp_h_06_b"]', 'MiltonDrive', 0, 1, 0, '{"x":-765.3,"y":331.414,"z":195.085}', 1300000),
(29, 'Seductive2Apartment', 'Appartement Séduisant 2', NULL, '{"x":-786.8663,"y":315.764,"z":186.913}', '{"x":-781.808,"y":315.866,"z":186.913}', NULL, '["apa_v_mp_h_06_c"]', 'MiltonDrive', 0, 1, 0, '{"x":-795.655,"y":326.611,"z":186.313}', 1300000),
(27, 'Monochrome3Apartment', 'Appartement Monochrome 3', NULL, '{"x":-774.012,"y":342.042,"z":195.686}', '{"x":-779.057,"y":342.063,"z":195.686}', NULL, '["apa_v_mp_h_05_b"]', 'MiltonDrive', 0, 1, 0, '{"x":-765.094,"y":330.976,"z":195.085}', 1300000),
(28, 'Seductive1Apartment', 'Appartement Séduisant 1', NULL, '{"x":-784.194,"y":323.636,"z":210.997}', '{"x":-779.751,"y":323.385,"z":210.997}', NULL, '["apa_v_mp_h_06_a"]', 'MiltonDrive', 0, 1, 0, '{"x":-766.263,"y":328.104,"z":210.396}', 1300000),
(26, 'Monochrome2Apartment', 'Appartement Monochrome 2', NULL, '{"x":-786.8663,"y":315.764,"z":186.913}', '{"x":-781.808,"y":315.866,"z":186.913}', NULL, '["apa_v_mp_h_05_c"]', 'MiltonDrive', 0, 1, 0, '{"x":-795.692,"y":326.762,"z":186.313}', 1300000),
(25, 'Monochrome1Apartment', 'Appartement Monochrome 1', NULL, '{"x":-784.194,"y":323.636,"z":210.997}', '{"x":-779.751,"y":323.385,"z":210.997}', NULL, '["apa_v_mp_h_05_a"]', 'MiltonDrive', 0, 1, 0, '{"x":-766.289,"y":328.086,"z":210.396}', 1300000),
(24, 'Sharp3Apartment', 'Appartement Persan 3', NULL, '{"x":-774.012,"y":342.042,"z":195.686}', '{"x":-779.057,"y":342.063,"z":195.686}', NULL, '["apa_v_mp_h_04_b"]', 'MiltonDrive', 0, 1, 0, '{"x":-765.503,"y":331.318,"z":195.085}', 1300000),
(23, 'Sharp2Apartment', 'Appartement Persan 2', NULL, '{"x":-786.8663,"y":315.764,"z":186.913}', '{"x":-781.808,"y":315.866,"z":186.913}', NULL, '["apa_v_mp_h_04_c"]', 'MiltonDrive', 0, 1, 0, '{"x":-795.642,"y":326.497,"z":186.313}', 1300000),
(22, 'Sharp1Apartment', 'Appartement Persan 1', NULL, '{"x":-784.194,"y":323.636,"z":210.997}', '{"x":-779.751,"y":323.385,"z":210.997}', NULL, '["apa_v_mp_h_04_a"]', 'MiltonDrive', 0, 1, 0, '{"x":-766.527,"y":327.89,"z":210.396}', 1300000),
(21, 'Vibrant3Apartment', 'Appartement Vibrant 3', NULL, '{"x":-774.012,"y":342.042,"z":195.686}', '{"x":-779.057,"y":342.063,"z":195.686}', NULL, '["apa_v_mp_h_03_b"]', 'MiltonDrive', 0, 1, 0, '{"x":-765.525,"y":330.851,"z":195.085}', 1300000),
(20, 'Vibrant2Apartment', 'Appartement Vibrant 2', NULL, '{"x":-786.8663,"y":315.764,"z":186.913}', '{"x":-781.808,"y":315.866,"z":186.913}', NULL, '["apa_v_mp_h_03_c"]', 'MiltonDrive', 0, 1, 0, '{"x":-795.607,"y":327.344,"z":186.313}', 1300000),
(19, 'Vibrant1Apartment', 'Appartement Vibrant 1', NULL, '{"x":-784.194,"y":323.636,"z":210.997}', '{"x":-779.751,"y":323.385,"z":210.997}', NULL, '["apa_v_mp_h_03_a"]', 'MiltonDrive', 0, 1, 0, '{"x":-765.885,"y":327.641,"z":210.396}', 1300000),
(18, 'Mody3Apartment', 'Appartement Mode 3', NULL, '{"x":-774.012,"y":342.042,"z":195.686}', '{"x":-779.057,"y":342.063,"z":195.686}', NULL, '["apa_v_mp_h_02_b"]', 'MiltonDrive', 0, 1, 0, '{"x":-765.303,"y":330.932,"z":195.085}', 1300000),
(17, 'Mody2Apartment', 'Appartement Mode 2', NULL, '{"x":-786.8663,"y":315.764,"z":186.913}', '{"x":-781.808,"y":315.866,"z":186.913}', NULL, '["apa_v_mp_h_02_c"]', 'MiltonDrive', 0, 1, 0, '{"x":-795.297,"y":327.092,"z":186.313}', 1300000),
(16, 'Mody1Apartment', 'Appartement Mode 1', NULL, '{"x":-784.194,"y":323.636,"z":210.997}', '{"x":-779.751,"y":323.385,"z":210.997}', NULL, '["apa_v_mp_h_02_a"]', 'MiltonDrive', 0, 1, 0, '{"x":-766.615,"y":327.878,"z":210.396}', 1300000),
(15, 'Modern3Apartment', 'Appartement Moderne 3', NULL, '{"x":-774.012,"y":342.042,"z":195.686}', '{"x":-779.057,"y":342.063,"z":195.686}', NULL, '["apa_v_mp_h_01_b"]', 'MiltonDrive', 0, 1, 0, '{"x":-765.386,"y":330.782,"z":195.08}', 1300000),
(14, 'Modern2Apartment', 'Appartement Moderne 2', NULL, '{"x":-786.8663,"y":315.764,"z":186.913}', '{"x":-781.808,"y":315.866,"z":186.913}', NULL, '["apa_v_mp_h_01_c"]', 'MiltonDrive', 0, 1, 0, '{"x":-795.735,"y":326.757,"z":186.313}', 1300000),
(13, 'Modern1Apartment', 'Appartement Moderne 1', NULL, '{"x":-784.194,"y":323.636,"z":210.997}', '{"x":-779.751,"y":323.385,"z":210.997}', NULL, '["apa_v_mp_h_01_a"]', 'MiltonDrive', 0, 1, 0, '{"x":-766.661,"y":327.672,"z":210.396}', 1300000),
(12, 'MiltonDrive', 'Milton Drive', '{"x":-775.17,"y":312.01,"z":84.658}', NULL, NULL, '{"x":-775.346,"y":306.776,"z":84.7}', '[]', NULL, 0, 0, 1, NULL, 0),
(11, 'TinselTowersApt12', 'Tinsel Towers, Apt 42', '{"y":37.025,"z":42.58,"x":-618.299}', '{"y":58.898,"z":97.2,"x":-603.301}', '{"y":58.941,"z":97.2,"x":-608.741}', '{"y":30.603,"z":42.524,"x":-620.017}', '[]', NULL, 1, 1, 0, '{"x":-622.173,"y":54.585,"z":96.599}', 1700000),
(10, 'HillcrestAvenue2868', '2868 Hillcrest Avenue', '{"y":620.494,"z":141.588,"x":-752.82}', '{"y":618.62,"z":143.153,"x":-759.317}', '{"y":617.629,"z":143.153,"x":-760.789}', '{"y":621.281,"z":141.254,"x":-750.919}', '[]', NULL, 1, 1, 0, '{"x":-762.504,"y":618.992,"z":135.53}', 1500000),
(9, 'HillcrestAvenue2874', '2874 Hillcrest Avenue', '{"x":-853.346,"y":696.678,"z":147.782}', '{"y":690.875,"z":151.86,"x":-859.961}', '{"y":688.361,"z":151.857,"x":-859.395}', '{"y":701.628,"z":147.773,"x":-855.007}', '[]', NULL, 1, 1, 0, '{"x":-858.543,"y":697.514,"z":144.253}', 1500000),
(8, 'MadWayneThunder', '2113 Mad Wayne Thunder', '{"y":454.955,"z":96.462,"x":-1294.433}', '{"x":-1289.917,"y":449.541,"z":96.902}', '{"y":446.322,"z":96.899,"x":-1289.642}', '{"y":455.453,"z":96.517,"x":-1298.851}', '[]', NULL, 1, 1, 0, '{"x":-1287.306,"y":455.901,"z":89.294}', 1500000),
(7, 'LowEndApartment', 'Appartement de base', '{"y":-1078.735,"z":28.4031,"x":292.528}', '{"y":-1007.152,"z":-102.002,"x":265.845}', '{"y":-1002.802,"z":-100.008,"x":265.307}', '{"y":-1078.669,"z":28.401,"x":296.738}', '[]', NULL, 1, 1, 0, '{"x":265.916,"y":-999.38,"z":-100.008}', 562500),
(6, 'HillcrestAvenue2862', '2862 Hillcrest Avenue', '{"y":596.58,"z":142.641,"x":-686.554}', '{"y":591.988,"z":144.392,"x":-681.728}', '{"y":590.608,"z":144.392,"x":-680.124}', '{"y":599.019,"z":142.059,"x":-689.492}', '[]', NULL, 1, 1, 0, '{"x":-680.46,"y":588.6,"z":136.769}', 1500000),
(5, 'WildOatsDrive', '3655 Wild Oats Drive', '{"y":502.696,"z":136.421,"x":-176.003}', '{"y":497.817,"z":136.653,"x":-174.349}', '{"y":495.069,"z":136.666,"x":-173.331}', '{"y":506.412,"z":135.0664,"x":-177.927}', '[]', NULL, 1, 1, 0, '{"x":-174.725,"y":493.095,"z":129.043}', 1500000),
(4, 'NorthConkerAvenue2044', '2044 North Conker Avenue', '{"y":440.8,"z":146.702,"x":346.964}', '{"y":437.456,"z":148.394,"x":341.683}', '{"y":435.626,"z":148.394,"x":339.595}', '{"x":350.535,"y":443.329,"z":145.764}', '[]', NULL, 1, 1, 0, '{"x":337.726,"y":436.985,"z":140.77}', 1500000),
(3, 'RichardMajesticApt2', 'Richard Majestic, Apt 2', '{"y":-379.165,"z":37.961,"x":-936.363}', '{"y":-365.476,"z":113.274,"x":-913.097}', '{"y":-367.637,"z":113.274,"x":-918.022}', '{"y":-382.023,"z":37.961,"x":-943.626}', '[]', NULL, 1, 1, 0, '{"x":-927.554,"y":-377.744,"z":112.674}', 1700000),
(2, 'NorthConkerAvenue2045', '2045 North Conker Avenue', '{"x":372.796,"y":428.327,"z":144.685}', '{"x":373.548,"y":422.982,"z":144.907},', '{"y":420.075,"z":145.904,"x":372.161}', '{"x":372.454,"y":432.886,"z":143.443}', '[]', NULL, 1, 1, 0, '{"x":377.349,"y":429.422,"z":137.3}', 1500000),
(1, 'WhispymoundDrive', '2677 Whispymound Drive', '{"y":564.89,"z":182.959,"x":119.384}', '{"x":117.347,"y":559.506,"z":183.304}', '{"y":557.032,"z":183.301,"x":118.037}', '{"y":567.798,"z":182.131,"x":119.249}', '[]', NULL, 1, 1, 0, '{"x":118.748,"y":566.573,"z":175.697}', 1500000),
(38, 'IntegrityWay28', '4 Integrity Way - Apt 28', NULL, '{"x":-31.409,"y":-594.927,"z":79.03}', '{"x":-26.098,"y":-596.909,"z":79.03}', NULL, '[]', 'IntegrityWay', 0, 1, 0, '{"x":-11.923,"y":-597.083,"z":78.43}', 1700000),
(39, 'IntegrityWay30', '4 Integrity Way - Apt 30', NULL, '{"x":-17.702,"y":-588.524,"z":89.114}', '{"x":-16.21,"y":-582.569,"z":89.114}', NULL, '[]', 'IntegrityWay', 0, 1, 0, '{"x":-26.327,"y":-588.384,"z":89.123}', 1700000),
(40, 'DellPerroHeights', 'Dell Perro Heights', '{"x":-1447.06,"y":-538.28,"z":33.74}', NULL, NULL, '{"x":-1440.022,"y":-548.696,"z":33.74}', '[]', NULL, 0, 0, 1, NULL, 0),
(41, 'DellPerroHeightst4', 'Dell Perro Heights - Apt 28', NULL, '{"x":-1452.125,"y":-540.591,"z":73.044}', '{"x":-1455.435,"y":-535.79,"z":73.044}', NULL, '[]', 'DellPerroHeights', 0, 1, 0, '{"x":-1467.058,"y":-527.571,"z":72.443}', 1700000),
(42, 'DellPerroHeightst7', 'Dell Perro Heights - Apt 30', NULL, '{"x":-1451.562,"y":-523.535,"z":55.928}', '{"x":-1456.02,"y":-519.209,"z":55.929}', NULL, '[]', 'DellPerroHeights', 0, 1, 0, '{"x":-1457.026,"y":-530.219,"z":55.937}', 1700000),
(69, 'MBWExecutive Contrast', 'MBW Executive Contrast', NULL, '{"x":-1392.74,"y":-480.18,"z":71.14}', '{"x":-1389.43,"y":-479.01,"z":71.14}', NULL, '["ex_sm_15_office_02a"]', 'MazeBankWest', 0, 1, 0, '{"x":-1390.76,"y":-479.22,"z":72.04}', 2700000),
(68, 'MBWExecutiveCool', 'MBW Executive Cool', NULL, '{"x":-1392.74,"y":-480.18,"z":71.14}', '{"x":-1389.43,"y":-479.01,"z":71.14}', NULL, '["ex_sm_15_office_02c"]', 'MazeBankWest', 0, 1, 0, '{"x":-1390.76,"y":-479.22,"z":72.04}', 2700000),
(67, 'MBWExecutiveRich', 'MBW Executive Rich', NULL, '{"x":-1392.74,"y":-480.18,"z":71.14}', '{"x":-1389.43,"y":-479.01,"z":71.14}', NULL, '["ex_sm_15_office_02b"]', 'MazeBankWest', 0, 1, 0, '{"x":-1390.76,"y":-479.22,"z":72.04}', 2700000),
(66, 'MBWOldSpiceVintage', 'MBW Old Spice Vintage', NULL, '{"x":-1392.74,"y":-480.18,"z":71.14}', '{"x":-1389.43,"y":-479.01,"z":71.14}', NULL, '["ex_sm_15_office_01c"]', 'MazeBankWest', 0, 1, 0, '{"x":-1390.76,"y":-479.22,"z":72.04}', 2700000),
(65, 'MBWOldSpiceClassical', 'MBW Old Spice Classical', NULL, '{"x":-1392.74,"y":-480.18,"z":71.14}', '{"x":-1389.43,"y":-479.01,"z":71.14}', NULL, '["ex_sm_15_office_01b"]', 'MazeBankWest', 0, 1, 0, '{"x":-1390.76,"y":-479.22,"z":72.04}', 2700000),
(63, 'MazeBankWest', 'Maze Bank West', '{"x":-1379.58,"y":-499.63,"z":32.22}', NULL, NULL, '{"x":-1378.95,"y":-502.82,"z":32.22}', '[]', NULL, 0, 0, 1, NULL, 0),
(64, 'MBWOldSpiceWarm', 'MBW Old Spice Warm', NULL, '{"x":-1392.74,"y":-480.18,"z":71.14}', '{"x":-1389.43,"y":-479.01,"z":71.14}', NULL, '["ex_sm_15_office_01a"]', 'MazeBankWest', 0, 1, 0, '{"x":-1390.76,"y":-479.22,"z":72.04}', 2700000),
(62, 'LBPowerBrokerPolished', 'LB Power Broker Polished', NULL, '{"x":-1579.53,"y":-564.89,"z":107.62}', '{"x":-1576.42,"y":-567.57,"z":107.62}', NULL, '["ex_sm_13_office_03c"]', 'LomBank', 0, 1, 0, '{"x":-1571.26,"y":-575.76,"z":107.52}', 3500000),
(61, 'LBPowerBrokerConservative', 'LB Power Broker Conservative', NULL, '{"x":-1579.53,"y":-564.89,"z":107.62}', '{"x":-1576.42,"y":-567.57,"z":107.62}', NULL, '["ex_sm_13_office_03b"]', 'LomBank', 0, 1, 0, '{"x":-1571.26,"y":-575.76,"z":107.52}', 3500000),
(60, 'LBPowerBrokerIce', 'LB Power Broker Ice', NULL, '{"x":-1579.53,"y":-564.89,"z":107.62}', '{"x":-1576.42,"y":-567.57,"z":107.62}', NULL, '["ex_sm_13_office_03a"]', 'LomBank', 0, 1, 0, '{"x":-1571.26,"y":-575.76,"z":107.52}', 3500000),
(59, 'LBExecutiveContrast', 'LB Executive Contrast', NULL, '{"x":-1579.53,"y":-564.89,"z":107.62}', '{"x":-1576.42,"y":-567.57,"z":107.62}', NULL, '["ex_sm_13_office_02a"]', 'LomBank', 0, 1, 0, '{"x":-1571.26,"y":-575.76,"z":107.52}', 3500000),
(58, 'LBExecutiveCool', 'LB Executive Cool', NULL, '{"x":-1579.53,"y":-564.89,"z":107.62}', '{"x":-1576.42,"y":-567.57,"z":107.62}', NULL, '["ex_sm_13_office_02c"]', 'LomBank', 0, 1, 0, '{"x":-1571.26,"y":-575.76,"z":107.52}', 3500000),
(57, 'LBExecutiveRich', 'LB Executive Rich', NULL, '{"x":-1579.53,"y":-564.89,"z":107.62}', '{"x":-1576.42,"y":-567.57,"z":107.62}', NULL, '["ex_sm_13_office_02b"]', 'LomBank', 0, 1, 0, '{"x":-1571.26,"y":-575.76,"z":107.52}', 3500000),
(56, 'LBOldSpiceVintage', 'LB Old Spice Vintage', NULL, '{"x":-1579.53,"y":-564.89,"z":107.62}', '{"x":-1576.42,"y":-567.57,"z":107.62}', NULL, '["ex_sm_13_office_01c"]', 'LomBank', 0, 1, 0, '{"x":-1571.26,"y":-575.76,"z":107.52}', 3500000),
(55, 'LBOldSpiceClassical', 'LB Old Spice Classical', NULL, '{"x":-1579.53,"y":-564.89,"z":107.62}', '{"x":-1576.42,"y":-567.57,"z":107.62}', NULL, '["ex_sm_13_office_01b"]', 'LomBank', 0, 1, 0, '{"x":-1571.26,"y":-575.76,"z":107.52}', 3500000),
(54, 'LBOldSpiceWarm', 'LB Old Spice Warm', NULL, '{"x":-1579.53,"y":-564.89,"z":107.62}', '{"x":-1576.42,"y":-567.57,"z":107.62}', NULL, '["ex_sm_13_office_01a"]', 'LomBank', 0, 1, 0, '{"x":-1571.26,"y":-575.76,"z":107.52}', 3500000),
(53, 'LomBank', 'Lom Bank', '{"x":-1581.36,"y":-558.23,"z":34.07}', NULL, NULL, '{"x":-1583.60,"y":-555.12,"z":34.07}', '[]', NULL, 0, 0, 1, NULL, 0),
(52, 'PowerBrokerPolished', 'Power Broker Polished', NULL, '{"x":-75.69,"y":-827.08,"z":242.43}', '{"x":-75.51,"y":-823.90,"z":242.43}', NULL, '["ex_dt1_11_office_03c"]', 'MazeBankBuilding', 0, 1, 0, '{"x":-71.81,"y":-814.34,"z":242.39}', 5000000),
(51, 'PowerBrokerConservative', 'Power Broker Conservative', NULL, '{"x":-75.69,"y":-827.08,"z":242.43}', '{"x":-75.51,"y":-823.90,"z":242.43}', NULL, '["ex_dt1_11_office_03b"]', 'MazeBankBuilding', 0, 1, 0, '{"x":-71.81,"y":-814.34,"z":242.39}', 5000000),
(50, 'PowerBrokerIce', 'Power Broker Ice', NULL, '{"x":-75.69,"y":-827.08,"z":242.43}', '{"x":-75.51,"y":-823.90,"z":242.43}', NULL, '["ex_dt1_11_office_03a"]', 'MazeBankBuilding', 0, 1, 0, '{"x":-71.81,"y":-814.34,"z":242.39}', 5000000),
(49, 'ExecutiveContrast', 'Executive Contrast', NULL, '{"x":-75.69,"y":-827.08,"z":242.43}', '{"x":-75.51,"y":-823.90,"z":242.43}', NULL, '["ex_dt1_11_office_02a"]', 'MazeBankBuilding', 0, 1, 0, '{"x":-71.81,"y":-814.34,"z":242.39}', 5000000),
(48, 'ExecutiveCool', 'Executive Cool', NULL, '{"x":-75.69,"y":-827.08,"z":242.43}', '{"x":-75.51,"y":-823.90,"z":242.43}', NULL, '["ex_dt1_11_office_02c"]', 'MazeBankBuilding', 0, 1, 0, '{"x":-71.81,"y":-814.34,"z":242.39}', 5000000),
(47, 'ExecutiveRich', 'Executive Rich', NULL, '{"x":-75.69,"y":-827.08,"z":242.43}', '{"x":-75.51,"y":-823.90,"z":242.43}', NULL, '["ex_dt1_11_office_02b"]', 'MazeBankBuilding', 0, 1, 0, '{"x":-71.81,"y":-814.34,"z":242.39}', 5000000),
(46, 'OldSpiceVintage', 'Old Spice Vintage', NULL, '{"x":-75.69,"y":-827.08,"z":242.43}', '{"x":-75.51,"y":-823.90,"z":242.43}', NULL, '["ex_dt1_11_office_01c"]', 'MazeBankBuilding', 0, 1, 0, '{"x":-71.81,"y":-814.34,"z":242.39}', 5000000),
(45, 'OldSpiceClassical', 'Old Spice Classical', NULL, '{"x":-75.69,"y":-827.08,"z":242.43}', '{"x":-75.51,"y":-823.90,"z":242.43}', NULL, '["ex_dt1_11_office_01b"]', 'MazeBankBuilding', 0, 1, 0, '{"x":-71.81,"y":-814.34,"z":242.39}', 5000000),
(43, 'MazeBankBuilding', 'Maze Bank Building', '{"x":-79.18,"y":-795.92,"z":43.35}', NULL, NULL, '{"x":-72.50,"y":-786.92,"z":43.40}', '[]', NULL, 0, 0, 1, NULL, 0),
(44, 'OldSpiceWarm', 'Old Spice Warm', NULL, '{"x":-75.69,"y":-827.08,"z":242.43}', '{"x":-75.51,"y":-823.90,"z":242.43}', NULL, '["ex_dt1_11_office_01a"]', 'MazeBankBuilding', 0, 1, 0, '{"x":-71.81,"y":-814.34,"z":242.39}', 5000000),
(70, 'MBWPowerBrokerIce', 'MBW Power Broker Ice', NULL, '{"x":-1392.74,"y":-480.18,"z":71.14}', '{"x":-1389.43,"y":-479.01,"z":71.14}', NULL, '["ex_sm_15_office_03a"]', 'MazeBankWest', 0, 1, 0, '{"x":-1390.76,"y":-479.22,"z":72.04}', 2700000),
(71, 'MBWPowerBrokerConvservative', 'MBW Power Broker Convservative', NULL, '{"x":-1392.74,"y":-480.18,"z":71.14}', '{"x":-1389.43,"y":-479.01,"z":71.14}', NULL, '["ex_sm_15_office_03b"]', 'MazeBankWest', 0, 1, 0, '{"x":-1390.76,"y":-479.22,"z":72.04}', 2700000),
(72, 'MBWPowerBrokerPolished', 'MBW Power Broker Polished', NULL, '{"x":-1392.74,"y":-480.18,"z":71.14}', '{"x":-1389.43,"y":-479.01,"z":71.14}', NULL, '["ex_sm_15_office_03c"]', 'MazeBankWest', 0, 1, 0, '{"x":-1390.76,"y":-479.22,"z":72.04}', 2700000),
(496, 'Bay City AvenueMotel1', 'Bay City Avenue', '{"x":-1308.9658203125,"y":-931.15521240234,"z":15.36}', '{"x":151.37,"y":-1007.54,"z":-99.97}', '{"x":151.37,"y":-1007.54,"z":-99.97}', '{"x":-1308.9658203125,"y":-931.15521240234,"z":16.357076644897}', '["hei_hw1_blimp_interior_v_motel_mp_milo_"]', NULL, 1, 0, NULL, '{"x":152.36,"y":-1000.68,"z":-100.0}', 43750),
(497, 'Bay City AvenueMotel2', 'Bay City Avenue', '{"x":-1310.7575683594,"y":-931.86700439453,"z":15.36}', '{"x":151.37,"y":-1007.54,"z":-99.97}', '{"x":151.37,"y":-1007.54,"z":-99.97}', '{"x":-1310.7575683594,"y":-931.86700439453,"z":16.357303619385}', '["hei_hw1_blimp_interior_v_motel_mp_milo_"]', NULL, 1, 0, NULL, '{"x":152.36,"y":-1000.68,"z":-100.0}', 43750),
(498, 'Bay City AvenueMotel3', 'Bay City Avenue', '{"x":-1317.9606933594,"y":-934.37451171875,"z":15.36}', '{"x":151.37,"y":-1007.54,"z":-99.97}', '{"x":151.37,"y":-1007.54,"z":-99.97}', '{"x":-1317.9606933594,"y":-934.37451171875,"z":16.358287811279}', '["hei_hw1_blimp_interior_v_motel_mp_milo_"]', NULL, 1, 0, NULL, '{"x":152.36,"y":-1000.68,"z":-100.0}', 43750),
(499, 'Bay City AvenueMotel4', 'Bay City Avenue', '{"x":-1319.7747802734,"y":-935.06658935547,"z":15.36}', '{"x":151.37,"y":-1007.54,"z":-99.97}', '{"x":151.37,"y":-1007.54,"z":-99.97}', '{"x":-1319.7747802734,"y":-935.06658935547,"z":16.35852432251}', '["hei_hw1_blimp_interior_v_motel_mp_milo_"]', NULL, 1, 0, NULL, '{"x":152.36,"y":-1000.68,"z":-100.0}', 43750),
(500, 'Bay City AvenueMotel5', 'Bay City Avenue', '{"x":-1329.3909912109,"y":-938.58111572266,"z":15.36}', '{"x":151.37,"y":-1007.54,"z":-99.97}', '{"x":151.37,"y":-1007.54,"z":-99.97}', '{"x":-1329.3909912109,"y":-938.58111572266,"z":15.357588768005}', '["hei_hw1_blimp_interior_v_motel_mp_milo_"]', NULL, 1, 0, NULL, '{"x":152.36,"y":-1000.68,"z":-100.0}', 43750),
(501, 'Bay City AvenueMotel6', 'Bay City Avenue', '{"x":-1331.1315917969,"y":-939.28826904297,"z":15.36}', '{"x":151.37,"y":-1007.54,"z":-99.97}', '{"x":151.37,"y":-1007.54,"z":-99.97}', '{"x":-1331.1315917969,"y":-939.28826904297,"z":15.357841491699}', '["hei_hw1_blimp_interior_v_motel_mp_milo_"]', NULL, 1, 0, NULL, '{"x":152.36,"y":-1000.68,"z":-100.0}', 43750),
(502, 'Vespucci BoulevardMotel7', 'Vespucci Boulevard', '{"x":-1339.1380615234,"y":-941.53643798828,"z":15.36}', '{"x":151.37,"y":-1007.54,"z":-99.97}', '{"x":151.37,"y":-1007.54,"z":-99.97}', '{"x":-1339.1380615234,"y":-941.53643798828,"z":15.357811927795}', '["hei_hw1_blimp_interior_v_motel_mp_milo_"]', NULL, 1, 0, NULL, '{"x":152.36,"y":-1000.68,"z":-100.0}', 43750),
(503, 'Vespucci BoulevardMotel8', 'Vespucci Boulevard', '{"x":-1338.0535888672,"y":-941.72857666016,"z":15.36}', '{"x":151.37,"y":-1007.54,"z":-99.97}', '{"x":151.37,"y":-1007.54,"z":-99.97}', '{"x":-1338.0535888672,"y":-941.72857666016,"z":15.358644485474}', '["hei_hw1_blimp_interior_v_motel_mp_milo_"]', NULL, 1, 0, NULL, '{"x":152.36,"y":-1000.68,"z":-100.0}', 43750);

-- --------------------------------------------------------

--
-- Structure de la table `shops`
--

CREATE TABLE IF NOT EXISTS `shops` (
`id` int(11) NOT NULL,
  `store` varchar(100) NOT NULL,
  `item` varchar(100) NOT NULL,
  `price` int(11) NOT NULL
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=68 ;

--
-- Contenu de la table `shops`
--

INSERT INTO `shops` (`id`, `store`, `item`, `price`) VALUES
(1, 'TwentyFourSeven', 'bread', 13),
(2, 'TwentyFourSeven', 'water', 12),
(7, 'TwentyFourSeven', 'donut', 2),
(8, 'TwentyFourSeven', 'dopebag', 15),
(9, 'TwentyFourSeven', 'tel', 500),
(10, 'TwentyFourSeven', 'sim', 50),
(12, 'RobsLiquor', 'bread', 13),
(13, 'RobsLiquor', 'water', 12),
(18, 'RobsLiquor', 'donut', 2),
(19, 'RobsLiquor', 'dopebag', 15),
(20, 'RobsLiquor', 'tel', 500),
(21, 'RobsLiquor', 'sim', 50),
(23, 'LTDgasoline', 'bread', 13),
(24, 'LTDgasoline', 'water', 12),
(29, 'LTDgasoline', 'donut', 2),
(30, 'LTDgasoline', 'dopebag', 15),
(31, 'LTDgasoline', 'tel', 500),
(32, 'LTDgasoline', 'sim', 50),
(34, 'TwentyFourSeven', 'radio', 200),
(35, 'RobsLiquor', 'radio', 200),
(36, 'LTDgasoline', 'radio', 200),
(49, 'Pharmacy', 'bandage', 200),
(50, 'Pharmacy', 'medikit', 5000),
(51, 'Ammunation', 'clip', 200),
(52, 'Ammunation', 'weapon_bat', 750),
(53, 'Ammunation', 'weapon_battleaxe', 1800),
(54, 'Ammunation', 'weapon_machete', 1500),
(55, 'Ammunation', 'weapon_switchblade', 2200),
(56, 'Ammunation', 'weapon_knife', 2000),
(57, 'Ammunation', 'gadget_parachute', 5000),
(58, 'Ammunation', 'weapon_flare', 3000),
(59, 'Ammunation', 'weapon_pistol', 20000),
(60, 'Ammunation', 'weapon_doubleaction', 100000),
(61, 'LTDgasoline', 'weapon_flashlight', 700),
(62, 'RobsLiquor', 'weapon_flashlight', 700),
(63, 'TwentyFourSeven', 'weapon_flashlight', 700),
(64, 'BlackMarket', 'lockpick', 200),
(65, 'BlackMarket', 'balisegps', 200),
(66, 'BlackMarket', 'tenuecasa', 200),
(67, 'BlackMarket', 'headbag', 200);

-- --------------------------------------------------------

--
-- Structure de la table `sim`
--

CREATE TABLE IF NOT EXISTS `sim` (
  `identifier` varchar(50) NOT NULL,
  `phone_number` varchar(10) DEFAULT NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Structure de la table `society_moneywash`
--

CREATE TABLE IF NOT EXISTS `society_moneywash` (
`id` int(11) NOT NULL,
  `identifier` varchar(60) NOT NULL,
  `society` varchar(60) NOT NULL,
  `amount` int(11) NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1 ROW_FORMAT=DYNAMIC AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Structure de la table `trunk_inventory`
--

CREATE TABLE IF NOT EXISTS `trunk_inventory` (
`id` int(11) NOT NULL,
  `plate` varchar(8) NOT NULL,
  `data` text NOT NULL,
  `owned` int(11) NOT NULL
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=76 ;

--
-- Contenu de la table `trunk_inventory`
--

INSERT INTO `trunk_inventory` (`id`, `plate`, `data`, `owned`) VALUES
(28, '95BBU014', '{}', 1),
(31, '06UVJ393', '{"weapons":[],"coffre":[]}', 0),
(36, '13VZT985', '{"coffre":[{"name":"woodenbox","count":400}]}', 0),
(44, '49TKN593', '{"coffre":[{"name":"woodenbox","count":400}]}', 0),
(46, '29NZU943', '{"coffre":[]}', 0),
(61, '88QOI124', '{}', 1),
(65, '11RRM523', '{"coffre":[{"name":"woodenbox","count":240}]}', 0),
(69, '25XBD904', '{"coffre":[]}', 0),
(75, '40TEG313', '{}', 1);

-- --------------------------------------------------------

--
-- Structure de la table `twitter_accounts`
--

CREATE TABLE IF NOT EXISTS `twitter_accounts` (
`id` int(11) NOT NULL,
  `username` varchar(50) CHARACTER SET utf8 NOT NULL DEFAULT '0',
  `password` varchar(50) COLLATE utf8mb4_bin NOT NULL DEFAULT '0',
  `avatar_url` varchar(255) COLLATE utf8mb4_bin DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Structure de la table `twitter_likes`
--

CREATE TABLE IF NOT EXISTS `twitter_likes` (
`id` int(11) NOT NULL,
  `authorId` int(11) DEFAULT NULL,
  `tweetId` int(11) DEFAULT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Structure de la table `twitter_tweets`
--

CREATE TABLE IF NOT EXISTS `twitter_tweets` (
`id` int(11) NOT NULL,
  `authorId` int(11) NOT NULL,
  `realUser` varchar(50) COLLATE utf8mb4_unicode_ci DEFAULT NULL,
  `message` varchar(256) COLLATE utf8mb4_unicode_ci NOT NULL,
  `time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  `likes` int(11) NOT NULL DEFAULT '0'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci AUTO_INCREMENT=1 ;

-- --------------------------------------------------------

--
-- Structure de la table `users`
--

CREATE TABLE IF NOT EXISTS `users` (
  `identifier` varchar(50) COLLATE utf8mb4_bin NOT NULL,
  `license` varchar(50) COLLATE utf8mb4_bin DEFAULT NULL,
  `name` varchar(255) COLLATE utf8mb4_bin DEFAULT '',
  `skin` longtext COLLATE utf8mb4_bin,
  `job` varchar(255) COLLATE utf8mb4_bin DEFAULT 'unemployed',
  `job_grade` int(11) DEFAULT '0',
  `job2` varchar(255) COLLATE utf8mb4_bin DEFAULT 'unemployed2',
  `job2_grade` int(11) DEFAULT '0',
  `loadout` longtext COLLATE utf8mb4_bin,
  `position` varchar(500) COLLATE utf8mb4_bin DEFAULT NULL,
  `permission_level` int(11) DEFAULT NULL,
  `group` varchar(50) COLLATE utf8mb4_bin DEFAULT NULL,
  `firstname` varchar(50) COLLATE utf8mb4_bin DEFAULT '',
  `lastname` varchar(50) COLLATE utf8mb4_bin DEFAULT '',
  `dateofbirth` varchar(25) COLLATE utf8mb4_bin DEFAULT '',
  `sex` varchar(10) COLLATE utf8mb4_bin DEFAULT '',
  `height` varchar(5) COLLATE utf8mb4_bin DEFAULT '',
  `status` longtext COLLATE utf8mb4_bin,
  `last_property` varchar(255) COLLATE utf8mb4_bin DEFAULT NULL,
  `phone_number` varchar(10) COLLATE utf8mb4_bin DEFAULT NULL,
  `is_dead` tinyint(1) DEFAULT '0',
  `money` int(11) DEFAULT NULL,
  `bank` int(11) DEFAULT NULL,
  `last_save` datetime DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_bin;

-- --------------------------------------------------------

--
-- Structure de la table `user_accounts`
--

CREATE TABLE IF NOT EXISTS `user_accounts` (
`id` int(11) NOT NULL,
  `identifier` varchar(255) NOT NULL,
  `name` varchar(255) NOT NULL,
  `money` double NOT NULL DEFAULT '0'
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=182 ;


-- --------------------------------------------------------

--
-- Structure de la table `user_gang`
--

CREATE TABLE IF NOT EXISTS `user_gang` (
  `identifier` varchar(50) NOT NULL,
  `name` varchar(50) NOT NULL,
  `grade` int(2) NOT NULL DEFAULT '0'
) ENGINE=MyISAM DEFAULT CHARSET=latin1;


-- --------------------------------------------------------

--
-- Structure de la table `user_inventory`
--

CREATE TABLE IF NOT EXISTS `user_inventory` (
`id` int(11) NOT NULL,
  `identifier` varchar(255) NOT NULL,
  `item` varchar(255) NOT NULL,
  `count` int(11) NOT NULL
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=62955 ;


-- --------------------------------------------------------

--
-- Structure de la table `user_licenses`
--

CREATE TABLE IF NOT EXISTS `user_licenses` (
`id` int(11) NOT NULL,
  `type` varchar(60) NOT NULL,
  `owner` varchar(60) NOT NULL
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=51 ;

--
-- Contenu de la table `user_licenses`
--

-- --------------------------------------------------------

--
-- Structure de la table `user_parking`
--

CREATE TABLE IF NOT EXISTS `user_parking` (
  `identifier` varchar(50) NOT NULL,
  `car` int(11) NOT NULL DEFAULT '2',
  `boat` int(11) NOT NULL DEFAULT '1',
  `plane` int(11) NOT NULL DEFAULT '0',
  `heli` int(11) NOT NULL DEFAULT '0'
) ENGINE=MyISAM DEFAULT CHARSET=latin1;


-- --------------------------------------------------------

--
-- Structure de la table `vehicleshop`
--

CREATE TABLE IF NOT EXISTS `vehicleshop` (
  `name` varchar(60) NOT NULL,
  `model` varchar(60) NOT NULL,
  `price` int(11) DEFAULT NULL,
  `category` varchar(60) NOT NULL DEFAULT ''
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Contenu de la table `vehicleshop`
--

INSERT INTO `vehicleshop` (`name`, `model`, `price`, `category`) VALUES
('Burrito', 'aburrito', 80000, 'hide_car'),
('Adder', 'adder', 750000, 'super'),
('Akuma', 'akuma', 33500, 'motorcycles'),
('Alpha', 'alpha', 30000, 'sports'),
('Ambulance', 'ambulance', 80000, 'hide_car'),
('Asea', 'asea', 8000, 'sedans'),
('Asterope', 'asterope', 14000, 'sedans'),
('Fourgon Blindé', 'astockade', 130000, 'hide_car'),
('Autarch', 'autarch', 700000, 'super'),
('Avarus', 'avarus', 20000, 'motorcycles'),
('Bagger', 'bagger', 15000, 'motorcycles'),
('Baller Sport', 'baller3', 80000, 'suvs'),
('Baller Sport LWD', 'baller4', 85000, 'suvs'),
('Banshee', 'banshee', 63500, 'sports'),
('Banshee 900R', 'banshee2', 430000, 'super'),
('Bati 801', 'bati', 47000, 'motorcycles'),
('Bati 801RR', 'bati2', 50000, 'motorcycles'),
('Benson', 'benson', 110000, 'hide_car'),
('Bestia GTS', 'bestiagts', 75000, 'sports'),
('BF400', 'bf400', 80000, 'motorcycles'),
('BF Injection', 'bfinjection', 40000, 'offroad'),
('Bifta', 'bifta', 10000, 'offroad'),
('Bison', 'bison', 24000, 'vans'),
('Bjxl', 'bjxl', 30000, 'suvs'),
('Blade', 'blade', 14500, 'muscle'),
('Blazer', 'blazer', 5000, 'offroad'),
('Blazer Hot-Rod', 'blazer3', 5500, 'offroad'),
('Blazer Sport', 'blazer4', 6000, 'offroad'),
('Blista', 'blista', 10000, 'compacts'),
('Blista Retro', 'blista2', 12500, 'sportsclassics'),
('Blista Monkey', 'blista3', 12500, 'hide_car'),
('BMX (velo)', 'bmx', 300, 'motorcycles'),
('Bobcat XL', 'bobcatxl', 30000, 'vans'),
('Bodhi', 'bodhi2', 32000, 'offroad'),
('Brawler', 'brawler', 33000, 'offroad'),
('Brioso R/A', 'brioso', 9000, 'compacts'),
('Btype', 'btype', 45000, 'sportsclassics'),
('Fränken Stange', 'btype2', 50000, 'sportsclassics'),
('Btype Luxe', 'btype3', 45000, 'sportsclassics'),
('Buccaneer', 'buccaneer', 19000, 'muscle'),
('Buccaneer Rider', 'buccaneer2', 33500, 'muscle'),
('Buffalo', 'buffalo', 24000, 'muscle'),
('Buffalo S', 'buffalo2', 27000, 'muscle'),
('Buffalo course', 'buffalo3', 28000, 'hide_car'),
('Bullet', 'bullet', 350000, 'super'),
('Burrito', 'burrito3', 80000, 'vans'),
('Buzzard', 'buzzard2', 500000, 'helis'),
('Camper', 'camper', 12000, 'vans'),
('Caracara', 'caracara2', 200000, 'offroad'),
('Carbonizzare', 'carbonizzare', 92000, 'sports'),
('Carbon RS', 'carbonrs', 35000, 'motorcycles'),
('Casco', 'casco', 57500, 'sportsclassics'),
('Cheburek', 'cheburek', 12000, 'sportsclassics'),
('Cheetah', 'cheetah', 450000, 'super'),
('Cheetah Classique', 'cheetah2', 90000, 'sportsclassics'),
('Chimera', 'chimera', 25000, 'motorcycles'),
('Chino', 'chino', 9000, 'muscle'),
('Chino Luxe', 'chino2', 16000, 'muscle'),
('Cliffhanger', 'cliffhanger', 19000, 'motorcycles'),
('Clique', 'clique', 55000, 'sportsclassics'),
('Club', 'club', 25000, 'sedans'),
('Cognoscenti Cabrio', 'cogcabrio', 14000, 'coupes'),
('Cognoscenti', 'cognoscenti', 55000, 'sedans'),
('Comet', 'comet2', 84000, 'sports'),
('Comet Retro', 'comet3', 104000, 'sports'),
('Comet Safari', 'comet4', 64000, 'sports'),
('Comet 5', 'comet5', 70000, 'sports'),
('contender', 'contender', 200000, 'offroad'),
('Coquette', 'coquette', 91000, 'sports'),
('Coquette Classic', 'coquette2', 60000, 'sportsclassics'),
('Coquette BlackFin', 'coquette3', 70000, 'sportsclassics'),
('Coquette D10', 'coquette4', 750000, 'super'),
('Cruiser (velo)', 'cruiser', 400, 'motorcycles'),
('Cuban 800', 'cuban800', 600000, 'planes'),
('Cyclone', 'cyclone', 350000, 'super'),
('Daemon', 'daemon', 16000, 'motorcycles'),
('Daemon The Lost', 'daemon2', 16000, 'motorcycles'),
('Defiler', 'defiler', 27000, 'motorcycles'),
('Deveste', 'deveste', 1700000, 'super'),
('Deviant', 'deviant', 18000, 'muscle'),
('Diablous', 'diablous', 22000, 'motorcycles'),
('Diablous Custom', 'diablous2', 30000, 'motorcycles'),
('Dilettante', 'dilettante', 9000, 'sedans'),
('Dinghy', 'dinghy', 180000, 'boats'),
('Dodo', 'dodo', 600000, 'planes'),
('Dominator', 'dominator', 25000, 'muscle'),
('Dominator Course', 'dominator2', 25000, 'hide_car'),
('Dominator GTX', 'dominator3', 35000, 'muscle'),
('Double T', 'double', 38000, 'motorcycles'),
('8F Obey', 'drafter', 79000, 'sports'),
('Dubsta', 'dubsta', 50000, 'suvs'),
('Dubsta Luxuary', 'dubsta2', 90000, 'suvs'),
('Dubsta 6x6', 'dubsta3', 55000, 'offroad'),
('Dukes', 'dukes', 34000, 'muscle'),
('Dukes ArtaP', 'dukes3', 16000, 'muscle'),
('Dune Buggy', 'dune', 10000, 'offroad'),
('Dynasty', 'dynasty', 7000, 'sportsclassics'),
('Elegy', 'elegy', 65000, 'sports'),
('Elegy Sport', 'elegy2', 70000, 'sports'),
('Ellie', 'ellie', 19500, 'muscle'),
('Emerus', 'emerus', 1200000, 'super'),
('Emperor', 'emperor', 8000, 'sedans'),
('Buffalo S EMS', 'emsbuffalo', 70000, 'hide_car'),
('Enduro', 'enduro', 14000, 'motorcycles'),
('Entity XXR', 'entity2', 220000, 'sports'),
('Esskey', 'esskey', 12000, 'motorcycles'),
('Everon', 'everon', 70000, 'offroad'),
('Exemplar', 'exemplar', 35000, 'sedans'),
('F620', 'f620', 14000, 'coupes'),
('Faction', 'faction', 32000, 'muscle'),
('Faction Rider', 'faction2', 18000, 'muscle'),
('Faction XL', 'faction3', 20000, 'muscle'),
('Fagaloa', 'fagaloa', 7500, 'sportsclassics'),
('Faggio Sport', 'faggio', 1000, 'motorcycles'),
('Faggio', 'faggio2', 500, 'motorcycles'),
('Faggio Custom', 'faggio3', 750, 'motorcycles'),
('Buffalo Banalisée', 'fbi', 63000, 'hide_car'),
('FCR', 'fcr', 15000, 'motorcycles'),
('FCR Custom', 'fcr2', 17000, 'motorcycles'),
('Felon', 'felon', 32000, 'sedans'),
('Felon GT', 'felon2', 15000, 'coupes'),
('Feltzer', 'feltzer2', 107999, 'sports'),
('Stirling GT', 'feltzer3', 67000, 'sportsclassics'),
('Fixter (velo)', 'fixter', 500, 'motorcycles'),
('FlashGT', 'flashgt', 95000, 'sports'),
('Plateau', 'flatbed', 150000, 'hide_car'),
('FMJ', 'fmj', 500000, 'super'),
('FQ2', 'fq2', 40000, 'suvs'),
('Freecrawler', 'freecrawler', 30000, 'offroad'),
('Fugitive', 'fugitive', 15500, 'sedans'),
('Furia', 'furia', 950000, 'super'),
('Furore GT', 'furoregt', 95000, 'sports'),
('Futo', 'futo', 30000, 'sports'),
('Gargoyle', 'gargoyle', 18000, 'motorcycles'),
('Gauntlet', 'gauntlet', 34000, 'muscle'),
('Gauntlet Course', 'gauntlet2', 42000, 'hide_car'),
('Gauntlet Classic', 'gauntlet3', 28000, 'muscle'),
('Gauntlet Hellfire', 'gauntlet4', 55000, 'muscle'),
('Gauntlet Classic Custom', 'gauntlet5', 80000, 'muscle'),
('GB200', 'gb200', 80000, 'sports'),
('Gang Burrito', 'gburrito', 30000, 'vans'),
('Burrito', 'gburrito2', 25000, 'vans'),
('Glendale', 'glendale', 7000, 'sedans'),
('Glendale custom', 'glendale2', 22000, 'muscle'),
('GP1', 'gp1', 750000, 'super'),
('Granger', 'granger', 80000, 'suvs'),
('Gresley', 'gresley', 25000, 'suvs'),
('GT 500', 'gt500', 90000, 'sportsclassics'),
('Guardian', 'guardian', 180000, 'offroad'),
('Habanero', 'habanero', 20000, 'vans'),
('Hakuchou', 'hakuchou', 48000, 'motorcycles'),
('Hakuchou Drag', 'hakuchou2', 50000, 'motorcycles'),
('Hellion', 'hellion', 47000, 'offroad'),
('Hermes', 'hermes', 26000, 'muscle'),
('Hexer', 'hexer', 16000, 'motorcycles'),
('Hotknife', 'hotknife', 39500, 'muscle'),
('Hotring', 'hotring', 45000, 'muscle'),
('Huntley S', 'huntley', 70000, 'suvs'),
('Hustler', 'hustler', 24000, 'muscle'),
('Imorgon', 'imorgon', 190000, 'sports'),
('Impaler', 'impaler', 31000, 'muscle'),
('Infernus', 'infernus', 200000, 'super'),
('Infernus Classique', 'infernus2', 100000, 'sportsclassics'),
('Ingot', 'ingot', 8000, 'sedans'),
('Innovation', 'innovation', 25000, 'motorcycles'),
('Intruder', 'intruder', 16500, 'sedans'),
('Issi', 'issi2', 6000, 'compacts'),
('Issi Retro', 'issi3', 2000, 'compacts'),
('Issi Sport', 'issi7', 60000, 'sports'),
('Itali GTB', 'italigtb', 500000, 'super'),
('Itali GTB Custom', 'italigtb2', 540000, 'super'),
('Itali GTO', 'italigto', 200000, 'sports'),
('Jackal', 'jackal', 34000, 'coupes'),
('JB700', 'jb700', 75000, 'sportsclassics'),
('Jester', 'jester', 60000, 'sports'),
('Jester Sport', 'jester2', 70000, 'hide_car'),
('Jester Classique', 'jester3', 63000, 'sports'),
('JetMax', 'jetmax', 180000, 'boats'),
('Journey', 'journey', 6000, 'vans'),
('Jugular', 'jugular', 79000, 'sports'),
('Kamacho', 'kamacho', 42000, 'offroad'),
('Kanjo', 'kanjo', 8000, 'compacts'),
('Khamelion', 'khamelion', 40000, 'coupes'),
('Komoda', 'komoda', 210000, 'sports'),
('Krieger', 'krieger', 1500000, 'super'),
('Kuruma', 'kuruma', 63000, 'sports'),
('Lectro', 'lectro', 25000, 'motorcycles'),
('Locust', 'locust', 82000, 'sports'),
('Lynx', 'lynx', 62000, 'sports'),
('Mamba', 'mamba', 80000, 'sports'),
('Manana', 'manana', 10000, 'sportsclassics'),
('Manchez', 'manchez', 24500, 'motorcycles'),
('Massacro', 'massacro', 91000, 'sports'),
('Massacro sport', 'massacro2', 96000, 'hide_car'),
('Mesa', 'mesa', 40000, 'suvs'),
('Mesa Trail', 'mesa3', 55000, 'suvs'),
('Michelli GT', 'michelli', 27000, 'sportsclassics'),
('Monroe', 'monroe', 85000, 'sportsclassics'),
('Moonbeam', 'moonbeam', 20000, 'vans'),
('Moonbeam Custom', 'moonbeam2', 25000, 'vans'),
('Nebula TURBO', 'nebula', 6000, 'sportsclassics'),
('Nemesis', 'nemesis', 13000, 'motorcycles'),
('Neo', 'neo', 102000, 'sports'),
('Pfister Neon', 'neon', 155275, 'sports'),
('Nero', 'nero', 850000, 'super'),
('Nero Custom', 'nero2', 1000000, 'super'),
('Nightblade', 'nightblade', 30000, 'motorcycles'),
('Nightshade', 'nightshade', 24000, 'muscle'),
('9F', 'ninef', 85000, 'sports'),
('9F Cabrio', 'ninef2', 90000, 'sports'),
('Novak', 'novak', 95000, 'hide_car'),
('Omnis', 'omnis', 130000, 'sports'),
('Oracle XS', 'oracle2', 35000, 'sedans'),
('Osiris', 'osiris', 550000, 'super'),
('Outlaw', 'outlaw', 35000, 'offroad'),
('Panto', 'panto', 2000, 'compacts'),
('Paradise', 'paradise', 17000, 'vans'),
('Paragon', 'paragon', 96000, 'sports'),
('Pariah', 'pariah', 80000, 'sports'),
('Patriot', 'patriot', 60000, 'suvs'),
('Bus Prison', 'pbus', 180000, 'hide_car'),
('Bus Musicale', 'pbus2', 400000, 'hide_car'),
('PCJ 600', 'pcj', 10000, 'motorcycles'),
('Penetrator', 'penetrator', 110000, 'sportsclassics'),
('Penumbra', 'penumbra', 80000, 'sports'),
('Penumbra FF', 'penumbra2', 90000, 'sports'),
('Peyote drag', 'peyote2', 32000, 'muscle'),
('Peyote Custom', 'peyote3', 20000, 'muscle'),
('811', 'pfister811', 210000, 'super'),
('Phoenix', 'phoenix', 35000, 'muscle'),
('Picador', 'picador', 12000, 'muscle'),
('Pigalle', 'pigalle', 30000, 'sportsclassics'),
('Buffalo S Police', 'polbuffalo', 72000, 'hide_car'),
('Bullet Police', 'polbullet', 380000, 'hide_car'),
('Gauntlet Police', 'polgauntlet', 70000, 'hide_car'),
('Stanier', 'police', 32000, 'hide_car'),
('Buffalo', 'police2', 70000, 'hide_car'),
('Cruiser', 'police3', 85000, 'hide_car'),
('Stanier Banalisée', 'police4', 26000, 'hide_car'),
('Moto', 'policeb', 30000, 'hide_car'),
('Fourgon transport', 'policet', 72000, 'hide_car'),
('Maverick', 'polmav', 550000, 'hide_heli'),
('Thrust Police', 'polthrust', 32500, 'hide_car'),
('Vacca Police', 'polvacca', 300000, 'hide_car'),
('Pony', 'pony', 35000, 'vans'),
('Pony Weed', 'pony2', 40000, 'vans'),
('Prairie', 'prairie', 10000, 'coupes'),
('Predator', 'predator', 250000, 'hide_boat'),
('Premier', 'premier', 14000, 'sedans'),
('Primo', 'primo', 12000, 'sedans'),
('Primo Custom', 'primo2', 15000, 'sedans'),
('X80 Proto', 'prototipo', 1200000, 'super'),
('Coil Raiden', 'raiden', 120101, 'sports'),
('Rancher XL', 'rancherxl', 35000, 'offroad'),
('Rapid GT', 'rapidgt', 81000, 'sports'),
('Rapid GT Cabrio', 'rapidgt2', 85000, 'sports'),
('Rapid GT3', 'rapidgt3', 35000, 'muscle'),
('RatBike', 'ratbike', 10000, 'motorcycles'),
('Ratloader', 'ratloader', 6000, 'vans'),
('Ratloader Custom', 'ratloader2', 35000, 'vans'),
('Reaper', 'reaper', 700000, 'super'),
('Rebel', 'rebel2', 18000, 'offroad'),
('Regina', 'regina', 7000, 'sportsclassics'),
('Retinue', 'retinue', 43500, 'sportsclassics'),
('Rhapsody', 'rhapsody', 4000, 'compacts'),
('Riata', 'riata', 36000, 'offroad'),
('Fourgon Blindé', 'riot', 130000, 'hide_car'),
('Fourgon Antiémeute', 'riot2', 500000, 'hide_car'),
('Rocoto', 'rocoto', 100000, 'suvs'),
('R Rocket', 'rrocket', 50000, 'motorcycles'),
('Ruffian', 'ruffian', 24000, 'motorcycles'),
('Ruiner', 'ruiner', 26000, 'coupes'),
('Rumpo', 'rumpo', 30000, 'vans'),
('Rumpo Trail', 'rumpo3', 27000, 'vans'),
('Ruston', 'ruston', 65000, 'sports'),
('Sabre Turbo', 'sabregt', 32000, 'muscle'),
('Sabre GT', 'sabregt2', 34000, 'muscle'),
('Sanchez Pro', 'sanchez', 26000, 'motorcycles'),
('Sanchez', 'sanchez2', 25000, 'motorcycles'),
('Sanctus', 'sanctus', 30000, 'motorcycles'),
('Sandking', 'sandking', 30000, 'offroad'),
('Sandking XL', 'sandking2', 35000, 'offroad'),
('Savestra', 'savestra', 45000, 'sportsclassics'),
('SC1', 'sc1', 450000, 'super'),
('Schafter', 'schafter2', 33000, 'sedans'),
('Schafter V12', 'schafter3', 55000, 'sports'),
('Schafter', 'schafter5', 120000, 'hide_car'),
('Schlagen', 'schlagen', 100000, 'sports'),
('Schwarzer', 'schwarzer', 95000, 'sports'),
('Scorcher (velo)', 'scorcher', 3400, 'motorcycles'),
('Seminole Frontier', 'seminole2', 20000, 'offroad'),
('Sentinel Cabrio', 'sentinel', 17000, 'coupes'),
('Sentinel XS', 'sentinel2', 14000, 'coupes'),
('Sentinel3', 'sentinel3', 60000, 'sports'),
('Seven 70', 'seven70', 108000, 'sports'),
('Sheava', 'sheava', 150000, 'super'),
('Slamvan', 'slamvan', 30000, 'vans'),
('Slamvan Custom', 'slamvan3', 40000, 'vans'),
('Sovereign', 'sovereign', 22000, 'motorcycles'),
('Specter', 'specter', 85000, 'sports'),
('Specter Custom', 'specter2', 89000, 'sports'),
('Stafford', 'stafford', 90000, 'muscle'),
('Stalion', 'stalion', 14000, 'muscle'),
('Stalion Course', 'stalion2', 37000, 'hide_car'),
('Stanier', 'stanier', 16500, 'sedans'),
('Stinger', 'stinger', 50000, 'sportsclassics'),
('Stinger GT', 'stingergt', 65000, 'sportsclassics'),
('Stratum', 'stratum', 9000, 'sedans'),
('Streiter', 'streiter', 75000, 'sports'),
('Limo', 'stretch', 120000, 'hide_car'),
('Sugoi', 'sugoi', 55000, 'sports'),
('Sultan', 'sultan', 33000, 'sedans'),
('Sultan Retro', 'sultan2', 32000, 'sedans'),
('Sultan RS', 'sultanrs', 120000, 'super'),
('Super Diamond', 'superd', 75000, 'sedans'),
('Surano', 'surano', 83000, 'sports'),
('Surfer', 'surfer', 14000, 'vans'),
('Surge', 'surge', 13500, 'sedans'),
('Swinger', 'swinger', 73500, 'sportsclassics'),
('T20', 't20', 1020000, 'super'),
('FoodTruck', 'taco', 150000, 'hide_car'),
('Tailgater', 'tailgater', 16000, 'sedans'),
('Taipan', 'taipan', 3500000, 'super'),
('Tampa', 'tampa', 15000, 'muscle'),
('Tampa Drift', 'tampa2', 90000, 'muscle'),
('Taxi', 'taxi', 30000, 'hide_car'),
('Tempesta', 'tempesta', 600000, 'super'),
('Thrax', 'thrax', 1200000, 'super'),
('Thrust', 'thrust', 22500, 'motorcycles'),
('Tigon', 'tigon', 750000, 'sportsclassics'),
('Torero', 'torero', 82750, 'sportsclassics'),
('Tornado', 'tornado', 7000, 'sportsclassics'),
('Tornado Rodriguez', 'tornado4', 7000, 'sportsclassics'),
('Tornado Custom', 'tornado5', 8000, 'sportsclassics'),
('Tornado Rat-rod', 'tornado6', 7000, 'sportsclassics'),
('Pegassi Toros', 'toros', 150000, 'suvs'),
('DépaneuseG', 'towtruck', 100000, 'hide_car'),
('DépaneuseP', 'towtruck2', 95000, 'hide_car'),
('Tri bike (velo)', 'tribike3', 2000, 'motorcycles'),
('Trophy Truck', 'trophytruck', 350000, 'offroad'),
('Buggy Raid', 'trophytruck2', 350000, 'offroad'),
('Tropos', 'tropos', 100000, 'sports'),
('Tulip', 'tulip', 30000, 'muscle'),
('Turismo Classique', 'turismo2', 78000, 'sportsclassics'),
('Turismo R', 'turismor', 700000, 'super'),
('Tyrant', 'tyrant', 340000, 'super'),
('Tyrus', 'tyrus', 800000, 'super'),
('Oracle Banalisée', 'umoracle', 60000, 'hide_car'),
('Vacca', 'vacca', 280000, 'super'),
('Vader', 'vader', 11000, 'motorcycles'),
('Vagner', 'vagner', 1260000, 'super'),
('Vagrant', 'vagrant', 110000, 'offroad'),
('Vamos', 'vamos', 32000, 'muscle'),
('Verlierer', 'verlierer2', 120000, 'sports'),
('Vigero', 'vigero', 31000, 'muscle'),
('Vindicator', 'vindicator', 35000, 'motorcycles'),
('Virgo', 'virgo', 8000, 'muscle'),
('Virgo Custom', 'virgo2', 17000, 'muscle'),
('Viseris', 'viseris', 70000, 'sportsclassics'),
('Visione', 'visione', 950000, 'super'),
('Voltic', 'voltic', 60000, 'sports'),
('Voodoo', 'voodoo', 15000, 'muscle'),
('Vortex', 'vortex', 21000, 'motorcycles'),
('VSTR', 'vstr', 130000, 'sports'),
('Warrener', 'warrener', 11000, 'sportsclassics'),
('Washington', 'washington', 15500, 'sedans'),
('Windsor', 'windsor', 45000, 'coupes'),
('Windsor Drop', 'windsor2', 80000, 'sedans'),
('Woflsbane', 'wolfsbane', 12000, 'motorcycles'),
('Ocelot XA-21', 'xa21', 1562500, 'super'),
('XLS', 'xls', 55000, 'suvs'),
('XLS', 'xls2', 145000, 'hide_car'),
('Yosemite', 'yosemite', 25000, 'vans'),
('Yosemite Drift', 'yosemite2', 45000, 'vans'),
('Yosemite Rancher', 'yosemite3', 30000, 'offroad'),
('Youga', 'youga', 80000, 'vans'),
('Youga Classique', 'youga2', 85000, 'vans'),
('Youga classic 4x4', 'youga3', 95000, 'vans'),
('Z190', 'z190', 40000, 'sportsclassics'),
('Zentorno', 'zentorno', 950000, 'super'),
('Zion', 'zion', 14000, 'coupes'),
('Zion Cabrio', 'zion2', 17000, 'coupes'),
('Zion classique', 'zion3', 30000, 'sportsclassics'),
('Zombie', 'zombiea', 15000, 'motorcycles'),
('Zombie Luxuary', 'zombieb', 16000, 'motorcycles'),
('Zorrusso', 'zorrusso', 850000, 'super'),
('Z-Type', 'ztype', 96500, 'sportsclassics');

-- --------------------------------------------------------

--
-- Structure de la table `vehicleshop_society`
--

CREATE TABLE IF NOT EXISTS `vehicleshop_society` (
  `model` varchar(60) NOT NULL,
  `society` varchar(60) NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=latin1;

--
-- Contenu de la table `vehicleshop_society`
--

INSERT INTO `vehicleshop_society` (`model`, `society`) VALUES
('aburrito', 'society_ammunation'),
('adder', 'society_state'),
('ambulance', 'society_ambulance'),
('astockade', 'society_ammunation'),
('benson', 'society_cluckin'),
('burrito3', 'society_bahama'),
('burrito3', 'society_cluckin'),
('burrito3', 'society_nightclub'),
('burrito3', 'society_unicorn'),
('carbonizzare', 'society_bahama'),
('dubsta', 'society_mecano'),
('emsbuffalo', 'society_ambulance'),
('fbi', 'society_ambulance'),
('fbi', 'society_police'),
('felon', 'society_taxi'),
('flatbed', 'society_mecano'),
('novak', 'society_state'),
('pbus', 'society_police'),
('pbus2', 'society_bahama'),
('pbus2', 'society_nightclub'),
('polbuffalo', 'society_police'),
('polbullet', 'society_police'),
('polgauntlet', 'society_police'),
('police', 'society_police'),
('police2', 'society_police'),
('police3', 'society_police'),
('police4', 'society_police'),
('policeb', 'society_police'),
('policet', 'society_police'),
('polmav', 'society_ambulance'),
('polmav', 'society_police'),
('polthrust', 'society_police'),
('polvacca', 'society_police'),
('predator', 'society_police'),
('riot', 'society_police'),
('riot2', 'society_police'),
('schafter3', 'society_nightclub'),
('schafter5', 'society_state'),
('stretch', 'society_state'),
('taco', 'society_cluckin'),
('taxi', 'society_taxi'),
('towtruck', 'society_mecano'),
('towtruck2', 'society_mecano'),
('umoracle', 'society_police'),
('xls2', 'society_state'),
('yosemite3', 'society_mecano'),
('yosemite3', 'society_vigneron'),
('youga2', 'society_tailor');

-- --------------------------------------------------------

--
-- Structure de la table `vehicle_categories`
--

CREATE TABLE IF NOT EXISTS `vehicle_categories` (
  `name` varchar(60) NOT NULL,
  `label` varchar(60) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

--
-- Contenu de la table `vehicle_categories`
--

INSERT INTO `vehicle_categories` (`name`, `label`) VALUES
('boats', 'Bateaux'),
('compacts', 'Compacts'),
('coupes', 'Coupés'),
('helis', 'Hélicos'),
('hide_boat', '<span style=''color: #eb4034''>Staff</span>'),
('hide_car', '<span style=''color: #eb4034''>Staff</span>'),
('hide_heli', '<span style=''color: #eb4034''>Staff</span>'),
('hide_plane', '<span style=''color: #eb4034''>Staff</span>'),
('motorcycles', 'Motos'),
('muscle', 'Muscle'),
('offroad', 'Off Road'),
('planes', 'Avions'),
('sedans', 'Sedans'),
('sports', 'Sports'),
('sportsclassics', 'Sports Classics'),
('super', 'Super'),
('suvs', 'SUVs'),
('vans', 'Vans');

--
-- Index pour les tables exportées
--

--
-- Index pour la table `accounts_logs`
--
ALTER TABLE `accounts_logs`
 ADD PRIMARY KEY (`id`);

--
-- Index pour la table `addon_account`
--
ALTER TABLE `addon_account`
 ADD UNIQUE KEY `name` (`name`), ADD UNIQUE KEY `name_2` (`name`);

--
-- Index pour la table `addon_account_data`
--
ALTER TABLE `addon_account_data`
 ADD PRIMARY KEY (`id`);

--
-- Index pour la table `addon_inventory`
--
ALTER TABLE `addon_inventory`
 ADD PRIMARY KEY (`name`);

--
-- Index pour la table `addon_inventory_items`
--
ALTER TABLE `addon_inventory_items`
 ADD PRIMARY KEY (`id`);

--
-- Index pour la table `ban_list`
--
ALTER TABLE `ban_list`
 ADD PRIMARY KEY (`license`);

--
-- Index pour la table `billing`
--
ALTER TABLE `billing`
 ADD PRIMARY KEY (`id`);

--
-- Index pour la table `datastore`
--
ALTER TABLE `datastore`
 ADD PRIMARY KEY (`name`);

--
-- Index pour la table `datastore_data`
--
ALTER TABLE `datastore_data`
 ADD PRIMARY KEY (`id`);

--
-- Index pour la table `dpkeybinds`
--
ALTER TABLE `dpkeybinds`
 ADD PRIMARY KEY (`id`);

--
-- Index pour la table `fine_types`
--
ALTER TABLE `fine_types`
 ADD PRIMARY KEY (`id`);

--
-- Index pour la table `inventories`
--
ALTER TABLE `inventories`
 ADD PRIMARY KEY (`name`);

--
-- Index pour la table `inventories_items`
--
ALTER TABLE `inventories_items`
 ADD PRIMARY KEY (`name`,`item`,`identifier`);

--
-- Index pour la table `items`
--
ALTER TABLE `items`
 ADD PRIMARY KEY (`name`);

--
-- Index pour la table `jobs`
--
ALTER TABLE `jobs`
 ADD PRIMARY KEY (`name`);

--
-- Index pour la table `job_grades`
--
ALTER TABLE `job_grades`
 ADD PRIMARY KEY (`id`);

--
-- Index pour la table `licenses`
--
ALTER TABLE `licenses`
 ADD PRIMARY KEY (`type`);

--
-- Index pour la table `open_car`
--
ALTER TABLE `open_car`
 ADD PRIMARY KEY (`id`);

--
-- Index pour la table `owned_keys`
--
ALTER TABLE `owned_keys`
 ADD PRIMARY KEY (`id`);

--
-- Index pour la table `owned_properties`
--
ALTER TABLE `owned_properties`
 ADD PRIMARY KEY (`id`);

--
-- Index pour la table `owned_vehicles`
--
ALTER TABLE `owned_vehicles`
 ADD PRIMARY KEY (`plate`);

--
-- Index pour la table `phone_app_chat`
--
ALTER TABLE `phone_app_chat`
 ADD PRIMARY KEY (`id`);

--
-- Index pour la table `phone_calls`
--
ALTER TABLE `phone_calls`
 ADD PRIMARY KEY (`id`);

--
-- Index pour la table `phone_messages`
--
ALTER TABLE `phone_messages`
 ADD PRIMARY KEY (`id`);

--
-- Index pour la table `phone_users_contacts`
--
ALTER TABLE `phone_users_contacts`
 ADD PRIMARY KEY (`id`);

--
-- Index pour la table `playerstattoos`
--
ALTER TABLE `playerstattoos`
 ADD PRIMARY KEY (`id`);

--
-- Index pour la table `properties`
--
ALTER TABLE `properties`
 ADD PRIMARY KEY (`id`);

--
-- Index pour la table `shops`
--
ALTER TABLE `shops`
 ADD PRIMARY KEY (`id`);

--
-- Index pour la table `society_moneywash`
--
ALTER TABLE `society_moneywash`
 ADD PRIMARY KEY (`id`) USING BTREE;

--
-- Index pour la table `trunk_inventory`
--
ALTER TABLE `trunk_inventory`
 ADD PRIMARY KEY (`id`), ADD UNIQUE KEY `plate` (`plate`);

--
-- Index pour la table `twitter_accounts`
--
ALTER TABLE `twitter_accounts`
 ADD PRIMARY KEY (`id`), ADD UNIQUE KEY `username` (`username`);

--
-- Index pour la table `twitter_likes`
--
ALTER TABLE `twitter_likes`
 ADD PRIMARY KEY (`id`), ADD KEY `FK_twitter_likes_twitter_accounts` (`authorId`), ADD KEY `FK_twitter_likes_twitter_tweets` (`tweetId`);

--
-- Index pour la table `twitter_tweets`
--
ALTER TABLE `twitter_tweets`
 ADD PRIMARY KEY (`id`), ADD KEY `FK_twitter_tweets_twitter_accounts` (`authorId`);

--
-- Index pour la table `users`
--
ALTER TABLE `users`
 ADD PRIMARY KEY (`identifier`);

--
-- Index pour la table `user_accounts`
--
ALTER TABLE `user_accounts`
 ADD PRIMARY KEY (`id`);

--
-- Index pour la table `user_gang`
--
ALTER TABLE `user_gang`
 ADD PRIMARY KEY (`identifier`);

--
-- Index pour la table `user_inventory`
--
ALTER TABLE `user_inventory`
 ADD PRIMARY KEY (`id`);

--
-- Index pour la table `user_licenses`
--
ALTER TABLE `user_licenses`
 ADD PRIMARY KEY (`id`);

--
-- Index pour la table `user_parking`
--
ALTER TABLE `user_parking`
 ADD PRIMARY KEY (`identifier`);

--
-- Index pour la table `vehicleshop`
--
ALTER TABLE `vehicleshop`
 ADD PRIMARY KEY (`model`,`category`);

--
-- Index pour la table `vehicleshop_society`
--
ALTER TABLE `vehicleshop_society`
 ADD PRIMARY KEY (`model`,`society`);

--
-- Index pour la table `vehicle_categories`
--
ALTER TABLE `vehicle_categories`
 ADD PRIMARY KEY (`name`);

--
-- AUTO_INCREMENT pour les tables exportées
--

--
-- AUTO_INCREMENT pour la table `accounts_logs`
--
ALTER TABLE `accounts_logs`
MODIFY `id` int(11) NOT NULL AUTO_INCREMENT,AUTO_INCREMENT=736;
--
-- AUTO_INCREMENT pour la table `addon_account_data`
--
ALTER TABLE `addon_account_data`
MODIFY `id` int(11) NOT NULL AUTO_INCREMENT,AUTO_INCREMENT=683;
--
-- AUTO_INCREMENT pour la table `addon_inventory_items`
--
ALTER TABLE `addon_inventory_items`
MODIFY `id` int(11) NOT NULL AUTO_INCREMENT,AUTO_INCREMENT=154;
--
-- AUTO_INCREMENT pour la table `billing`
--
ALTER TABLE `billing`
MODIFY `id` int(11) NOT NULL AUTO_INCREMENT,AUTO_INCREMENT=13;
--
-- AUTO_INCREMENT pour la table `datastore_data`
--
ALTER TABLE `datastore_data`
MODIFY `id` int(11) NOT NULL AUTO_INCREMENT,AUTO_INCREMENT=95;
--
-- AUTO_INCREMENT pour la table `fine_types`
--
ALTER TABLE `fine_types`
MODIFY `id` int(11) NOT NULL AUTO_INCREMENT,AUTO_INCREMENT=45;
--
-- AUTO_INCREMENT pour la table `job_grades`
--
ALTER TABLE `job_grades`
MODIFY `id` int(11) NOT NULL AUTO_INCREMENT,AUTO_INCREMENT=374;
--
-- AUTO_INCREMENT pour la table `open_car`
--
ALTER TABLE `open_car`
MODIFY `id` int(11) NOT NULL AUTO_INCREMENT,AUTO_INCREMENT=360;
--
-- AUTO_INCREMENT pour la table `owned_keys`
--
ALTER TABLE `owned_keys`
MODIFY `id` int(11) NOT NULL AUTO_INCREMENT,AUTO_INCREMENT=32;
--
-- AUTO_INCREMENT pour la table `owned_properties`
--
ALTER TABLE `owned_properties`
MODIFY `id` int(11) NOT NULL AUTO_INCREMENT,AUTO_INCREMENT=75;
--
-- AUTO_INCREMENT pour la table `phone_app_chat`
--
ALTER TABLE `phone_app_chat`
MODIFY `id` int(11) NOT NULL AUTO_INCREMENT,AUTO_INCREMENT=5;
--
-- AUTO_INCREMENT pour la table `phone_calls`
--
ALTER TABLE `phone_calls`
MODIFY `id` int(11) NOT NULL AUTO_INCREMENT,AUTO_INCREMENT=101;
--
-- AUTO_INCREMENT pour la table `phone_messages`
--
ALTER TABLE `phone_messages`
MODIFY `id` int(11) NOT NULL AUTO_INCREMENT,AUTO_INCREMENT=11498;
--
-- AUTO_INCREMENT pour la table `phone_users_contacts`
--
ALTER TABLE `phone_users_contacts`
MODIFY `id` int(11) NOT NULL AUTO_INCREMENT,AUTO_INCREMENT=382;
--
-- AUTO_INCREMENT pour la table `playerstattoos`
--
ALTER TABLE `playerstattoos`
MODIFY `id` int(11) NOT NULL AUTO_INCREMENT,AUTO_INCREMENT=196;
--
-- AUTO_INCREMENT pour la table `properties`
--
ALTER TABLE `properties`
MODIFY `id` int(11) NOT NULL AUTO_INCREMENT,AUTO_INCREMENT=537;
--
-- AUTO_INCREMENT pour la table `shops`
--
ALTER TABLE `shops`
MODIFY `id` int(11) NOT NULL AUTO_INCREMENT,AUTO_INCREMENT=68;
--
-- AUTO_INCREMENT pour la table `society_moneywash`
--
ALTER TABLE `society_moneywash`
MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;
--
-- AUTO_INCREMENT pour la table `trunk_inventory`
--
ALTER TABLE `trunk_inventory`
MODIFY `id` int(11) NOT NULL AUTO_INCREMENT,AUTO_INCREMENT=76;
--
-- AUTO_INCREMENT pour la table `twitter_accounts`
--
ALTER TABLE `twitter_accounts`
MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;
--
-- AUTO_INCREMENT pour la table `twitter_likes`
--
ALTER TABLE `twitter_likes`
MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;
--
-- AUTO_INCREMENT pour la table `twitter_tweets`
--
ALTER TABLE `twitter_tweets`
MODIFY `id` int(11) NOT NULL AUTO_INCREMENT;
--
-- AUTO_INCREMENT pour la table `user_accounts`
--
ALTER TABLE `user_accounts`
MODIFY `id` int(11) NOT NULL AUTO_INCREMENT,AUTO_INCREMENT=182;
--
-- AUTO_INCREMENT pour la table `user_inventory`
--
ALTER TABLE `user_inventory`
MODIFY `id` int(11) NOT NULL AUTO_INCREMENT,AUTO_INCREMENT=62955;
--
-- AUTO_INCREMENT pour la table `user_licenses`
--
ALTER TABLE `user_licenses`
MODIFY `id` int(11) NOT NULL AUTO_INCREMENT,AUTO_INCREMENT=51;
--
-- Contraintes pour les tables exportées
--

--
-- Contraintes pour la table `twitter_likes`
--
ALTER TABLE `twitter_likes`
ADD CONSTRAINT `FK_twitter_likes_twitter_accounts` FOREIGN KEY (`authorId`) REFERENCES `twitter_accounts` (`id`),
ADD CONSTRAINT `FK_twitter_likes_twitter_tweets` FOREIGN KEY (`tweetId`) REFERENCES `twitter_tweets` (`id`) ON DELETE CASCADE;

--
-- Contraintes pour la table `twitter_tweets`
--
ALTER TABLE `twitter_tweets`
ADD CONSTRAINT `FK_twitter_tweets_twitter_accounts` FOREIGN KEY (`authorId`) REFERENCES `twitter_accounts` (`id`);

/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
