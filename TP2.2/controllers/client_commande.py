#! /usr/bin/python
# -*- coding:utf-8 -*-
from flask import Blueprint
from flask import Flask, request, render_template, redirect, url_for, abort, flash, session, g
from datetime import datetime
from connexion_db import get_db

client_commande = Blueprint('client_commande', __name__,
                        template_folder='templates')


@client_commande.route('/client/commande/add', methods=['POST'])
def client_commande_add():
    mycursor = get_db().cursor()

    client_id = session['user_id']
    sql = "SELECT * FROM panier WHERE id_user = %s"
    mycursor.execute(sql, client_id)
    items_panier = mycursor.fetchall()
    if items_panier is None or len(items_panier) < 1:
        flash(u'Pas d\'articles dans le panier')
        return redirect(url_for('client_article.client_article_show'))
    
    date_commande = datetime.now().strftime('%Y-%m-%d %H:%M:%S')
    tuple_insert = (date_commande, client_id, '1') # 1: etat de commande
    sql = "INSERT INTO commande (date_achat, id_user, id_etat) VALUES (%s,%s,%s)"
    mycursor.execute(sql, tuple_insert)
    sql = "SELECT last_insert_id() as last_insert_id"
    mycursor.execute(sql)
    commande_id = mycursor.fetchone()
    print(commande_id, tuple_insert)

    for item in items_panier:
        tuple_insert = (client_id, item['id_telephone'])
        sql = "DELETE FROM panier WHERE id_user = %s AND id_telephone = %s"
        mycursor.execute(sql, tuple_insert)
        sql = "SELECT prix FROM telephone WHERE id_telephone = %s"
        mycursor.execute(sql, item['id_telephone'])
        prix = mycursor.fetchone ()
        sql = "INSERT INTO ligne_commande (id_commande, id_telephone, prix, quantite) VALUES (%s,%s,%s,%s)"
        tuple_insert = (commande_id['last_insert_id'], item['id_telephone'], prix['prix'], item['quantite'])
        print(tuple_insert)
        mycursor.execute(sql, tuple_insert)
    get_db().commit()

    flash(u'Commande ajoutée')
    return redirect('/client/article/show')
    #return redirect(url_for('client_index'))



@client_commande.route('/client/commande/show', methods=['get','post'])
def client_commande_show():
    mycursor = get_db().cursor()

    sql = "select * from commande"
    mycursor.execute(sql)
    commandes = mycursor.fetchall()


    sql = "SELECT SUM(prix * quantite) as pt FROM ligne_commande GROUP BY id_commande"
    mycursor.execute(sql)
    prix_total = mycursor.fetchone()["pt"]

    sql = "select * from ligne_commande lc join commande c on lc.id_commande=c.id_commande"
    mycursor.execute(sql)
    articles_commande = mycursor.fetchall()

    return render_template('client/commandes/show.html', commandes=commandes, articles_commande=articles_commande, prix_total=prix_total)

