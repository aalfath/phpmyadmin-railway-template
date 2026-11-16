<?php
/*
 * Railway template hardening for phpMyAdmin.
 * Loaded after the image's config.inc.php (it includes /etc/phpmyadmin/conf.d/*.php).
 */

// The image allows passwordless logins by default; this template does not.
foreach (array_keys($cfg['Servers'] ?? []) as $serverId) {
    $cfg['Servers'][$serverId]['AllowNoPassword'] = false;
}

// No outbound "new version available" check from the UI; updates come through this repo.
$cfg['VersionCheck'] = false;
