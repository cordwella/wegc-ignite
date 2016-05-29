# WEGC Ignite

Ignite is a QR code based scavanger hunt game, built by myself and Lana Cleverley during our time as
Wellington East Girls College technology prefects.

Game play is simple, we placed a bunch of QR codes (generated from the site) around the school which students can scan. (Most of these QR codes were only worth one point however this can be set from the database and double points are awarded when the marker house and the user house are the same) This act adds points to their account, and also to their (school) house (they have to provide this information when they sign up).

Currently it is not that simple (due to some extra code we added) to run this for another school, however I intend to release another version of this with a working admin panel and more documentation so that other schools can use it.

The Facebook page that we updated during the week we ran ignite can be found [here](https://www.facebook.com/wegcignite/), and our announcement video can be found [here](https://www.youtube.com/watch?v=64Wh9KMe0Eg&feature=youtu.be)

## Python Libraries
Ignite uses the [Flask](http://flask.pocoo.org/) web framework, MariaDB as it's database (accessed with MySQLdb), as well as the pyqrcode, hashids, and bycrypt python libraries.

Ignite can be started by running 'python __init__.py' from the directory in which it is saved.

## License
The original code for Ignite is released under the MIT Open Source License.
Images of house prefects in the static/images, were taken at the WEGC Athletics Day and are reproduced with permission here.
The rest of the images in the static/images directory are (c) Lana Cleverley and used with permission for this project only.

[Bootstrap](http://getbootstrap.com) is used here under the terms of the MIT license.
[jQuery](https://jquery.org) is used here under the terms of the MIT license.
The [Grayscale theme](http://startbootstrap.com/template-overviews/grayscale/) for bootstrap is also used under the MIT License.
