#! /usr/bin/python
# -*- coding:utf-8 -*-
from flask import Blueprint
from flask import Flask, request, render_template, redirect, url_for, abort, flash, session, g

from connexion_db import get_db

client_commentaire = Blueprint('client_commentaire', __name__,
                        template_folder='templates')

@client_commentaire.route('/client/comment/add', methods=['POST'])
def client_comment_add():
    mycursor = get_db().cursor()
    article_id = request.form.get('idArticle')
    client_id = session['user_id']
    commentaire = request.form.get('commentaire')
    note = request.form.get('note')

    sql = "insert into commentaire(article_id, user_id, commentaire, note) values (%s,%s,%s,%s)"
    mycursor.execute(sql, (article_id, client_id, commentaire, note))
    get_db().commit()

    return redirect('/client/article/details/'+article_id)
    #return redirect(url_for('client_article_details', id=int(article_id)))

@client_commentaire.route('/client/comment/delete', methods=['POST'])
def client_comment_delete():
    mycursor = get_db().cursor()
    article_id = request.form.get('idArticle')
    commentaire_id = request.form.get('idAvis')

    sql = "delete from commentaire where commentaire.id = %s"
    mycursor.execute(sql, (commentaire_id))
    get_db().commit()

    return redirect('/client/article/details/'+article_id)
    #return redirect(url_for('client_article_details', id=int(article_id)))