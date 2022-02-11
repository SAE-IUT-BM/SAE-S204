# mysql --user=mtheven8 --password=2904 --host=serveurmysql --database=BDD_mtheven8
# SELECT * FROM INFORMATION_SCHEMA.TABLE_CONSTRAINTS WHERE `table_schema` LIKE 'BDD_mtheven8' AND `constraint_type` = 'FOREIGN KEY';

ALTER TABLE panier DROP FOREIGN KEY fk_panier_user;
ALTER TABLE telephone
DROP FOREIGN KEY fk_telephone_commande,
DROP FOREIGN KEY fk_telephone_categorie,
DROP FOREIGN KEY fk_telephone_marque,
DROP FOREIGN KEY fk_telephone_couleur;
ALTER TABLE fournit
DROP FOREIGN KEY fk_fournit_telephone,
DROP FOREIGN KEY fk_fournit_fournisseur;
ALTER TABLE ligne_commande
DROP FOREIGN KEY fk_ligneCommande_commande,
DROP FOREIGN KEY fk_ligneCommande_panier,
DROP FOREIGN KEY fk_ligneCommande_telephone;
ALTER TABLE passe DROP FOREIGN KEY fk_passe_user;

DROP TABLE IF EXISTS passe;
DROP TABLE IF EXISTS ligne_commande;
DROP TABLE IF EXISTS fournit;
DROP TABLE IF EXISTS marque;
DROP TABLE IF EXISTS fournisseur;
DROP TABLE IF EXISTS couleur;
DROP TABLE IF EXISTS categorie;
DROP TABLE IF EXISTS modele;
DROP TABLE IF EXISTS telephone;
DROP TABLE IF EXISTS panier;
DROP TABLE IF EXISTS commande;
DROP TABLE IF EXISTS etat;
DROP TABLE IF EXISTS user;

CREATE TABLE user(
   id INT(11) NOT NULL AUTO_INCREMENT,
   username VARCHAR(50),
   password VARCHAR(100),
   role VARCHAR(50),
   est_actif VARCHAR(50),
   pseudo VARCHAR(50),
   email VARCHAR(50),
   PRIMARY KEY(id)
);

CREATE TABLE etat(
   id_etat INT(11) NOT NULL AUTO_INCREMENT,
   libelle VARCHAR(50),
   PRIMARY KEY(id_etat)
);

CREATE TABLE commande(
   id_commande INT(11) NOT NULL AUTO_INCREMENT,
   date_achat VARCHAR(50),
   PRIMARY KEY(id_commande)
);

CREATE TABLE modele(
   id_modele INT(11) NOT NULL AUTO_INCREMENT,
   libelle VARCHAR(50),
   PRIMARY KEY(id_modele)
);

CREATE TABLE categorie(
   id_categorie INT(11) NOT NULL AUTO_INCREMENT,
   libelle VARCHAR(50),
   PRIMARY KEY(id_categorie)
);

CREATE TABLE couleur(
   id_couleur INT(11) NOT NULL AUTO_INCREMENT,
   libelle VARCHAR(50),
   PRIMARY KEY(id_couleur)
);

CREATE TABLE fournisseur(
   id_fournisseur INT(11) NOT NULL AUTO_INCREMENT,
   libelle VARCHAR(50),
   PRIMARY KEY(id_fournisseur)
);

CREATE TABLE marque(
   id_marque INT(11) NOT NULL AUTO_INCREMENT,
   libelle VARCHAR(50),
   PRIMARY KEY(id_marque)
);

CREATE TABLE telephone(
   id_telephone INT(11) NOT NULL AUTO_INCREMENT,
   nom VARCHAR(50),
   prix VARCHAR(50),
   id_modele INT,
   id_categorie INT,
   id_marque INT,
   id_couleur INT,
   image VARCHAR(255),
   PRIMARY KEY(id_telephone)
);

CREATE TABLE fournit(
   id_telephone INT,
   id_fournisseur INT,
   PRIMARY KEY(id_telephone, id_fournisseur)
);

CREATE TABLE panier(
   id_panier INT(11) NOT NULL AUTO_INCREMENT,
   id_user INT NOT NULL,
   id_telephone INT NOT NULL,
   date_ajout VARCHAR(50),
   quantite INT(50),
   PRIMARY KEY(id_panier)
);

CREATE TABLE ligne_commande(
   id_commande INT,
   id_panier INT,
   id_telephone INT,
   prix_unit VARCHAR(50),
   PRIMARY KEY(id_commande, id_panier, id_telephone)
);

CREATE TABLE passe(
   id_user INT,
   id_etat INT,
   id_commande INT,
   PRIMARY KEY(id_user, id_etat, id_commande)
);


ALTER TABLE panier
ADD CONSTRAINT fk_panier_user FOREIGN KEY (id_user) REFERENCES user(id);
ALTER TABLE telephone
ADD CONSTRAINT fk_telephone_commande FOREIGN KEY (id_modele) REFERENCES modele(id_modele),
ADD CONSTRAINT fk_telephone_categorie FOREIGN KEY (id_categorie) REFERENCES categorie(id_categorie),
ADD CONSTRAINT fk_telephone_marque FOREIGN KEY (id_marque) REFERENCES marque(id_marque),
ADD CONSTRAINT fk_telephone_couleur FOREIGN KEY (id_couleur) REFERENCES couleur(id_couleur);
ALTER TABLE fournit
ADD CONSTRAINT fk_fournit_telephone FOREIGN KEY (id_telephone) REFERENCES telephone(id_telephone),
ADD CONSTRAINT fk_fournit_fournisseur FOREIGN KEY (id_fournisseur) REFERENCES fournisseur(id_fournisseur);
ALTER TABLE ligne_commande
ADD CONSTRAINT fk_ligneCommande_commande FOREIGN KEY (id_commande) REFERENCES commande(id_commande),
ADD CONSTRAINT fk_ligneCommande_panier FOREIGN KEY (id_panier) REFERENCES panier(id_panier),
ADD CONSTRAINT fk_ligneCommande_telephone FOREIGN KEY (id_telephone) REFERENCES telephone(id_telephone);
ALTER TABLE passe
ADD CONSTRAINT fk_passe_user FOREIGN KEY (id_user) REFERENCES user(id),
ADD CONSTRAINT fk_passe_etat FOREIGN KEY (id_etat) REFERENCES etat(id_etat),
ADD CONSTRAINT fk_passe_commande FOREIGN KEY (id_commande) REFERENCES commande(id_commande);



INSERT INTO user (id, email, username, password, role,  est_actif) VALUES
(null, 'admin@admin.fr', 'admin', 'sha256$pBGlZy6UukyHBFDH$2f089c1d26f2741b68c9218a68bfe2e25dbb069c27868a027dad03bcb3d7f69a', 'ROLE_admin', 1),
(null, 'client@client.fr', 'client', 'sha256$Q1HFT4TKRqnMhlTj$cf3c84ea646430c98d4877769c7c5d2cce1edd10c7eccd2c1f9d6114b74b81c4', 'ROLE_client',   1),
(null, 'client2@client2.fr', 'client2', 'sha256$ayiON3nJITfetaS8$0e039802d6fac2222e264f5a1e2b94b347501d040d71cfa4264cad6067cf5cf3', 'ROLE_client',   1);

INSERT INTO categorie(id_categorie, libelle) VALUES
(null, 'mobile'),
(null, 'fixe');

INSERT INTO marque(id_marque, libelle) VALUES
(null, 'Samsung'),
(null, 'Apple'),
(null, 'Huawei'),
(null, 'Xiaomi'),
(null, 'Honor'),
(null, 'Oppo'),
(null, 'Sony'),
(null, 'Wiko');

INSERT INTO modele(id_modele, libelle) VALUES
(null, 'Note'),
(null, 'S'),
(null, 'iphone'),
(null, 'P'),
(null, 'M'),
(null, 'honor'),
(null, 'A'),
(null, 'Xperia'),
(null, 'Power');

INSERT INTO fournisseur(id_fournisseur, libelle) VALUES
(null, 'SITEPRO13'),
(null, 'PAP MOBILE'),
(null, 'PRODEALEE'),
(null, 'EHUA STORE');

INSERT INTO couleur(id_couleur, libelle) VALUES
(null, 'Noir'),
(null, 'Gris'),
(null, 'Blanc'),
(null, 'Rouge'),
(null, 'Bleu');

INSERT INTO telephone (id_telephone, nom, prix, id_modele, id_categorie, id_marque, id_couleur, image) VALUES
(null, 'Note10', 950, 1, 1, 1, 1, null);

