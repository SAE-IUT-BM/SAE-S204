DROP TABLE IF EXISTS passe;
DROP TABLE IF EXISTS ligne_commande;
DROP TABLE IF EXISTS fournit;
DROP TABLE IF EXISTS telephone;
DROP TABLE IF EXISTS marque;
DROP TABLE IF EXISTS fournisseur;
DROP TABLE IF EXISTS couleur;
DROP TABLE IF EXISTS categorie;
DROP TABLE IF EXISTS modele;
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

CREATE TABLE panier(
   id_panier INT(11) NOT NULL AUTO_INCREMENT,
   date_ajout VARCHAR(50),
   id_user INT NOT NULL,
   PRIMARY KEY(id_panier),
   FOREIGN KEY(id_user) REFERENCES user(id)
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
   libelle VARCHAR(50),
   prix VARCHAR(50),
   id_modele INT NOT NULL,
   id_categorie INT NOT NULL,
   id_marque INT NOT NULL,
   id_couleur INT NOT NULL,
   PRIMARY KEY(id_telephone),
   FOREIGN KEY(id_modele) REFERENCES modele(id_modele),
   FOREIGN KEY(id_categorie) REFERENCES categorie(id_categorie),
   FOREIGN KEY(id_marque) REFERENCES marque(id_marque),
   FOREIGN KEY(id_couleur) REFERENCES couleur(id_couleur)
);

CREATE TABLE fournit(
   id_telephone INT,
   id_fournisseur INT,
   PRIMARY KEY(id_telephone, id_fournisseur),
   FOREIGN KEY(id_telephone) REFERENCES telephone(id_telephone),
   FOREIGN KEY(id_fournisseur) REFERENCES fournisseur(id_fournisseur)
);

CREATE TABLE ligne_commande(
   id_commande INT,
   id_panier INT,
   id_telephone INT,
   prix_unit VARCHAR(50),
   quantite VARCHAR(50),
   PRIMARY KEY(id_commande, id_panier, id_telephone),
   FOREIGN KEY(id_commande) REFERENCES commande(id_commande),
   FOREIGN KEY(id_panier) REFERENCES panier(id_panier),
   FOREIGN KEY(id_telephone) REFERENCES telephone(id_telephone)
);

CREATE TABLE passe(
   id_user INT,
   id_etat INT,
   id_commande INT,
   PRIMARY KEY(id_user, id_etat, id_commande),
   FOREIGN KEY(id_user) REFERENCES user(id),
   FOREIGN KEY(id_etat) REFERENCES etat(id_etat),
   FOREIGN KEY(id_commande) REFERENCES commande(id_commande)
);

INSERT INTO user (id, email, username, password, role,  est_actif) VALUES
(null, 'admin@admin.fr', 'admin', 'sha256$pBGlZy6UukyHBFDH$2f089c1d26f2741b68c9218a68bfe2e25dbb069c27868a027dad03bcb3d7f69a', 'ROLE_admin', 1),
(null, 'client@client.fr', 'client', 'sha256$Q1HFT4TKRqnMhlTj$cf3c84ea646430c98d4877769c7c5d2cce1edd10c7eccd2c1f9d6114b74b81c4', 'ROLE_client',   1),
(null, 'client2@client2.fr', 'client2', 'sha256$ayiON3nJITfetaS8$0e039802d6fac2222e264f5a1e2b94b347501d040d71cfa4264cad6067cf5cf3', 'ROLE_client',   1);


