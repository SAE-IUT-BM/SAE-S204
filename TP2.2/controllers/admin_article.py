#! /usr/bin/python
# -*- coding:utf-8 -*-
from flask import Blueprint
from flask import Flask, request, render_template, redirect, url_for, abort, flash, session, g

from connexion_db import get_db

admin_article = Blueprint('admin_article', __name__,
                        template_folder='templates')

@admin_article.route('/admin/article/show')
def show_article():
    mycursor = get_db().cursor()

    sql = "select * from telephone"
    mycursor.execute(sql)
    articles = mycursor.fetchall()

    sql = "select * from modele"
    mycursor.execute(sql)
    modeles = mycursor.fetchall()

    sql = "select * from marque"
    mycursor.execute(sql)
    marques = mycursor.fetchall()

    sql = "select * from categorie"
    mycursor.execute(sql)
    categories = mycursor.fetchall()

    return render_template('admin/article/show_article.html', articles=articles, modeles=modeles, marques=marques, categories=categories)

@admin_article.route('/admin/article/add', methods=['GET'])
def add_article():
    mycursor = get_db().cursor()
    types_articles = None
    return render_template('admin/article/add_article.html', types_articles=types_articles)

@admin_article.route('/admin/article/add', methods=['POST'])
def valid_add_article():
    mycursor = get_db().cursor()
    nom = request.form.get('nom', '')
    modele = request.form.get('modele', '')
    marque = request.form.get('marque', '')
    categorie = request.form.get('categorie', '')
    prix = request.form.get('prix', '')

    sql="insert into telephone(nom, modele, marque, categorie, prix) values (%s,%s,%s,%S,%s)"
    mycursor.execute(sql,(nom,modele,marque,categorie,prix))
    get_db().commit()

    print(u'article ajouté , nom: ', nom, ' - modele:', modele, ' - marque:', marque, ' - categorie:', categorie, ' - prix:', prix)
    message = u'article ajouté , nom:'+nom + '- modele:' + modele + '- marque:' + marque + '- categorie:' + categorie + ' - prix:' + prix
    flash(message)
    return redirect(url_for('admin_article.show_article'))

@admin_article.route('/admin/article/comment/<int:id>', methods=['GET'])
def comment_article(id):
    mycursor = get_db().cursor()

    sql = "select * from telephone where id_telephone=%s"
    mycursor.execute(sql,(id))
    articles = mycursor.fetchall()

    sql = "select * from commentaire where article_id = %s"
    mycursor.execute(sql,(id))
    comment = mycursor.fetchall()

    sql = "select * from user"
    mycursor.execute(sql)
    users = mycursor.fetchall()

    return render_template('admin/article/comment_article.html', comment=comment, articles=articles, users=users)

@admin_article.route('/admin/article/delete', methods=['POST'])
def delete_article():
    mycursor = get_db().cursor()
    id = request.form.get('idArticle', '')

    sql = "delete from ligne_commande where id_telephone = %s"
    mycursor.execute(sql, (id))
    get_db().commit()

    sql = "delete from telephone where id_telephone = %s"
    mycursor.execute(sql, (id))
    get_db().commit()

    print("un article supprimé, id :", id)
    flash(u'un article supprimé, id : ' + id)
    return redirect(url_for('admin_article.show_article'))

@admin_article.route('/admin/article/delete_comment', methods=['POST'])
def delete_comment():
    mycursor = get_db().cursor()
    id = request.form.get('idComment', '')

    sql = "delete from commentaire where id = %s"
    mycursor.execute(sql, (id))
    get_db().commit()

    print("un commentaire supprimé, id :", id)
    flash(u'un commentaire supprimé, id : ' + id)
    return redirect(url_for('admin_article.show_article'))

@admin_article.route('/admin/article/edit/<int:id>', methods=['GET'])
def edit_article(id):
    mycursor = get_db().cursor()

    sql = "select * from telephone where id_telephone=%s"
    mycursor.execute(sql, (id))
    article = mycursor.fetchone()

    types_articles = None
    return render_template('admin/article/edit_article.html', article=article, types_articles=types_articles)

@admin_article.route('/admin/article/edit', methods=['POST'])
def valid_edit_article():
    nom = request.form['nom']
    id = request.form.get('id', '')
    type_article_id = request.form.get('type_article_id', '')
    #type_article_id = int(type_article_id)
    prix = request.form.get('prix', '')
    stock = request.form.get('stock', '')
    description = request.form.get('description', '')
    image = request.form.get('image', '')

    print(u'article modifié , nom : ', nom, ' - type_article:', type_article_id, ' - prix:', prix, ' - stock:', stock, ' - description:', description, ' - image:', image)
    message = u'article modifié , nom:'+nom + '- type_article:' + type_article_id + ' - prix:' + prix + ' - stock:'+  stock + ' - description:' + description + ' - image:' + image
    flash(message)
    return redirect(url_for('admin_article.show_article'))