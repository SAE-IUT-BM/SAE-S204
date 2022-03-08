#! /usr/bin/python
# -*- coding:utf-8 -*-
from flask import Blueprint
from flask import Flask, request, render_template, redirect, url_for, abort, flash, session, g

from connexion_db import get_db

client_article = Blueprint('client_article', __name__,
                        template_folder='templates')

@client_article.route('/client/index')
@client_article.route('/client/article/show')      # remplace /client
def client_article_show():                                 # remplace client_index
    mycursor = get_db().cursor()

    sql = "select * from telephone"
    mycursor.execute(sql)
    telephones = mycursor.fetchall()
    articles = telephones

    sql = "select * from couleur"
    mycursor.execute(sql)
    couleur = mycursor.fetchall()
    types_articles = couleur

    sql = "SELECT id_panier, telephone.id_telephone, prix, nom, quantite FROM panier INNER JOIN telephone ON telephone.id_telephone = panier.id_telephone"
    mycursor.execute(sql)
    articles_panier = mycursor.fetchall()

    sql = "SELECT SUM(prix * quantite) AS prix FROM panier INNER JOIN telephone ON telephone.id_telephone = panier.id_telephone"
    mycursor.execute(sql)
    prix_total = mycursor.fetchone()
    return render_template('client/boutique/panier_article.html', articles=articles, articlesPanier=articles_panier, prix_total=prix_total, itemsFiltre=types_articles)

@client_article.route('/client/article/details/<int:id>', methods=['GET'])
def client_article_details(id):
    mycursor = get_db().cursor()
    client_id = session['user_id']

    sql = "select * from telephone where id_telephone=%s"
    mycursor.execute(sql,(id))
    article = mycursor.fetchone()

    sql = "select * from commentaire"
    mycursor.execute(sql)
    commentaires = mycursor.fetchall()

    sql = "select * from ligne_commande, commande where ligne_commande.id_telephone=%s and commande.id_user=%s"
    mycursor.execute(sql,(id, client_id))
    commandes_articles = mycursor.fetchall()

    return render_template('client/boutique/article_details.html', article=article, commentaires=commentaires, commandes_articles=commandes_articles)
