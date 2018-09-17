'use strict';

function init(app) {
    app.get('*', (req, _res, next) => {
        console.log('Request was made to: ' + req.originalUrl);
        return next();
    });

    app.get('/', (_req, res) => res.redirect('/home'));

    app.use('/lookup', require('./lookup'));
    app.use('/home', require('./home'));
}

module.exports = {
    init: init
};