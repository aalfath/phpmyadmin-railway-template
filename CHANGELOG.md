# Changelog

Each entry is one version of this Railway template. Breaking changes are listed first.

## 5.2.3-1 (2026-11-16)

- First release: phpMyAdmin 5.2.3 (`phpmyadmin:5.2.3-apache@sha256:e4b3eb5305cd42d21512bb55def2bab52625d56df927ad4ee1864a9354c84d40`), PHP 8.3.
- Cookie login only; passwordless logins are refused.
- Fixes Apache's "More than one MPM loaded" crash loop on Railway: the start script keeps only `mpm_prefork`.
- Apache listens on Railway's `PORT`; `PMA_ABSOLUTE_URI` is set from the Railway public domain.
- Stable cookie secret from `PMA_BLOWFISH_SECRET`; upload limit 512 MB.
