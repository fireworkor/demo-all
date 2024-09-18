// ==UserScript==
// @name         pvelogin pve免登录脚本
// @namespace    http://tampermonkey.net/
// @version      2024-01-19
// @description  try to take over the world!
// @author       You
// @match        https://192.168.1.166:8006*/*
// @icon         data:image/gif;base64,R0lGODlhAQABAAAAACH5BAEKAAEALAAAAAABAAEAAAICTAEAOw==
// @grant        none
// ==/UserScript==

(function() {
    'use strict';

    const requestBody = {
        username: 'xxxxxx',
        password: 'xxxxxx',
        realm: 'pam',
        'new-format': 1
    };

    fetch('https://192.168.1.166:8006/api2/extjs/access/ticket', {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json'
        },
        body: JSON.stringify(requestBody)
    })
        .then(response => response.json())
        .then(data => {
            console.log('Ticket:', data.data.ticket);
            const expires = new Date();
            expires.setTime(expires.getTime() + 3600000); // 1 hour
            document.cookie = `PVEAuthCookie=${ data.data.ticket}; domain=192.168.1.166; path=/; expires=${expires.toUTCString()}`;

        })
        .catch(error => {
            console.error('Error:', error);
        });
    // Your code here...
})();
