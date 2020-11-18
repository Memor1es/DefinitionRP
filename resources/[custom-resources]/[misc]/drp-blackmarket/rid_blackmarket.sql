USE `essentialmode`;

CREATE TABLE IF NOT EXISTS `black_market` (
	`id` int(11) NOT NULL AUTO_INCREMENT,
	`item` varchar(255) NOT NULL,
	`price` int(11) NOT NULL,
	`stock` int(11) NOT NULL,
	`zone` varchar(255) NOT NULL,
	`category` varchar(255) NOT NULL,

	PRIMARY KEY (`id`)
);

INSERT INTO `black_market` (`item`, `price`, `stock`, `zone`, `category`) VALUES
	('WEAPON_DOUBLEACTION', 3000, 0, 'BlackMarket', 'pistol'),
	('WEAPON_ASSAULTRIFLE', 50000, 0, 'BlackMarket', 'rifle'),
;
