---
type: post
title: "How FIDO2 works technically"
tags: ["fido2", "security", "yubikey", "passkey"]
date: 2024-11-23T11:48:09+02:00
images: ["/assets/pexels-cottonbro-5474292.webp"]
image_alt: |
    A hand enters the picture from the right holding a key connected to a FIDO2
    key by a key ring. Both the key and the FIDO2 key are black on a light grey
    background.
description: |
    In this article, I explain how FIDO2 keys work technically and how they
    protect their users from phishing attacks - for non-technical beginners as
    well as experienced software developers.
summary: |
    In this article, I explain how FIDO2 keys work technically and how they
    protect their users from phishing attacks - for non-technical beginners as
    well as experienced software developers.
toc: false
draft: false
---

In this article I will explain how FIDO2, an open standard, generally
implemented due to physical security keys in form of USB A or C sticks, work. Of
course there are other implementations too, but USB sticks are the most common
ones. So I will use "stick" to represent all implementations.

We will explore what FIDO2 is and have a look at the mechanisms how the FIDO2
sticks protect their users against the threat of phishing attacks. I will try
to explain the topic for non-technical as well as technical users. This is
really important to me, due to the high security level of the sticks, their easy
applicability - especially for non-technical end users - and their meanwhile
cheap price.

FIDO2 sticks offer a lot of benefits over "classic" multi factor authenticators
like Google's or Microsoft's time-based one-time password (TOTP) authenticators.
If my description is still to technical for you, then please don't hesitate to
let me know where I could improve my explanations, so I reach more people.

{{< toc >}}

## FIDO2, a brief introduction

FIDO2 is a so called "open standard", developed by the fido (fast identity
online) alliance. The alliance has a lot of company's working together on a new
and secure way of authentication, by building multiple open standards, not only
FIDO2. Google, Apple, Microsoft and Amazon are big partners of the alliance,
just to name a few.

One goal of the FIDO2 standard and the alliance is, to make passwords obsolete.
We relied on passwords for so many years now and we know that they are the
opposite of secure. That's one reason why we use password vaults and services to
store a new secret for each service or website we register on.

A password is a secret and we just sending the secret to someone else and have
to trust, that they keep it also safe and secure. But they often don't.
Passwords and user data is breached everyday. And users are humans. They
recycle passwords over and over, again and again.

As a rule of thumb, passwords are saved "hashed" on the servers of the website
we register for. A "hash" is a reproducible product of an algorithm, a one-way
road, so the password is not saved in clear, readable text on the servers, but
the hash is. That way the service can re-hash the password we send for login
every time and then they just have to compare the hashes, the products of the
algorithm.

It is unlikely, but not impossible, that these hashes can be turned back into a
clear text, and therefore be readable again. When the service we give our secret
uses a weak hashing-algorithm like the broken MD5, it is even very likely that
our password can be turned into clear text again. And even if not, with enough
time and enough compute power, every stolen password hash is likely to be
unsafe.

But there is a solution. A better way to express trust and to authenticate
against a website. Better then sharing an (often) shared "secret". Now its
getting unsexy for non-technical readers - the solution is called asymmetrical
encryption.

We all use it every day, Some use it more consciously than others, but we all
use it. When visiting my website for example. I enforce you as a visitor, to
visit my website with encryption, with TLS to be precise. When you visit
<span style="white-space:nowrap;">**http**://lukasrotermund.de</span>, the
unencrypted version of my website, I redirect you to
<span style="white-space:nowrap;">**https**://lukasrotermund.de</span>, the
encrypted version, like every website should do nowadays.

You can compare asymmetrical encryption with real world keys. There are two
matching keys in asymmetrical encryption, a private key, that is meant to be
kept private and a public key that is meant to be shared publicly. Each of these
keys can lock "a lock" (encrypt a message/ text) but the same key can not open
it, only its counterpart can.

Thinking of a website, when you as a visitor type **https://lukasrotermund.de**
into your address bar of your browser, your browser generates a new shared key
that is used for a private communication between your browser and my website. To
send me your shared key, your browser sends a request (a lock) to my server and
locks (encrypts) it with my websites public key. Everybody on the internet is
able to get my websites public key, but only my server is able can unlock the
request you sent through the internet, from someones untrusted server to another
ones untrusted server, until it reaches my websites server.

Now only my server can unlock the lock (the encrypted request) with its unshared
private key. And now that my server knows the key, generated by your browser, it
can send you all the HTML files you request, locked (encrypted) with our secret,
shared key, that only our browser and my server know.

FIDO2 uses a similar way to verify, that we are the user that we pretend to be.
Not the same flow, but the same asymmetrical encryption and the separation of a
private and a public key. This way, we only have to share our public key instead
of a secret. And when hackers gain access of our public key, e.g. by hacking the
websites server/ database, we are still save and can sleep well.

## How FIDO2 uses asymmetrical encryption

### Non-technical

The previous example focused more on encryption, but FIDO2 uses asymmetrical
encryption for something called **signing**. When my server knows you and your
public key (due to a registration process) and you try to log into my website,
I can send you a random generated text as a challenge, so that you can verify,
that you are who you pretend to be.

When you, or better your FIDO2 "device", are able to encrypt/ lock (sign) the
message I send you and I am able to decrypt/ unlock the encrypted/ locked text
with your public key you gave me while your registration and the decryption
result also matches the text I expect it to be, then you had just proven to me,
that you are in possession of the private, counterpart key I expect you to have.

That's it, roughly spoken. That's the magic behind the new password and
secret-less authentication. Just a simple encryption and decryption process to
prove that you are the right person.

Of course FIDO2 can do more, but we'll look into that later.

### Technical

FIDO2 is not a single thing, it is based on a protocol and a standard. CTAP
(Client to authenticator protocol), the protocol, and WebAuthn (Web
Authentication) the W3C standard. CTAP is responsible for the communication
between the client, e.g. a browser or the OS, and the authenticator (e.g.
hardware device, or secure chips in laptops or smartphones).

WebAuthn as a standard on the other hand, defines the communication between the
browser and the service (server), also called relying party, or short RP. It
offers a Javascript API for the client to communicate via CTAP with the
authenticator and it defines the communication with the RP and everything beyond
like storing certificates, generating challenges or HTTPS as a transport
protocol between the client and the RP.

The process behind FIDO2 is roughly comparable to a password-less, key-based SSH
login to a server. SSH also uses a challenge-response process for authorising
users. Applied to FIDO2, the authenticator device holds the private keys secure,
immutable and not readable from the outside and the generated private key is
stored on the RP side. Disclaimer, yes its possible to destroy the device and
open its case to read the private keys, but then the device is broken and can't
be used with CTAP anymore.

For the challenge-response process, the RP generates a cryptographically secure,
random and unique BLOB in a secure and controlled environment. The BLOB is
typically a byte array with a length of 16 or 32 bytes and its Base64URL
encoded. Additionally to the challenge, the RP has to store an expiry timestamp
and the information if the challenge was already used.

The generated challenge can now be shared with the client, which then starts a
CTAP via the WebAuthn API (js). The authenticator can now sign the challenge,
after the user authorized it by touching the device, scanning the right
fingerprint or presenting the right face. All the signing, CTAP handling and key
related stuff is handled within the device, that's important to understand. Your
private keys will never leave the device. The signed challenge is now send back
to the RP which can now verify the signed challenge with the known public key.

## Why does FIDO2 mitigates phishing

OK nice, now we know how FIDO2 uses asymmetrical encryption to make old, stinky
passwords (OSP) obsolete. But how does this protects us from phishing and why is
my OSP in combination with my 2FA time-based one-time password (TOTP) not secure
enough?

The important factor here is *the human*. When a malicious actor tries to break
into my company by preparing a perfect looking phishing site and sending it to
my employee, we now have to rely on the human sitting in front of its computer
to recognise the attack.

This sounds trivial, but in times of pretty good LLMs (large language models,
e.g. ChatGPT, and many more) these attacks are written in a perfect language
without the old, classic mistakes. And when the malicious attacker is
professional enough, like a state driven APT (advanced persistent threat), a
stealthy threat actor, they have enough resources and enough time to prepare
perfect phishing attacks.

Side note, if you are interested in protecting your self against these APTs and
adversaries, have a look at my previous blog post
**[Cybersecurity introduction and the MITRE ATT&CK framework]({{< ref "cybersecurity-introduction-and-the-mitre-att&ck-framework" >}})**
to get a foot in the door.

Now back to the phishing attack. Our employee clicks on the link to the phishing
site, e.g. a clone of the companies SaaS HR software, where employees can manage
their requests to leave, or see their shifts, and the employee has no mistrust
in the site. Then they navigate to the login and enter their credentials and
get prompted to enter a 2FA TOTP.

For the attacker its now just a matter of milliseconds to use the provided
information to take control of the account by providing them to the real SaaS
application and then exchange the 2FA to their own.

Humans make mistakes, and that is OK, we just have to consider this, when we
think of hardening the security against malicious threat actors - especially in
times of hybrid warfare with aggressive countries like Russia and not seldom
also China. But this also takes place between competing companies, or from
unfriendly ex employees.

But how does FIDO2 helps us now? Let's take a look!

### Non-technical

We've already learned, that with FIDO2, their is a communication between the
service I what to login and my FIDO2 device/ authenticator. But isn't it
possible that a phishing site sends the request from the browser to my FIDO2
device and the steal my account with this request?

A clear no. It is not possible for many technical reasons. First of all, your
FIDO2 device checks the domain of each incoming request and only does the
challenge signing for known domains. And your FIDO2 device is not totally alone
while protecting your login, it has also help from your browser.

The browser has an interface for the website to offer the ability for a
password-less login called WebAuthn. WebAuthn is the one, adding the domain to
the request to your FIDO2 device, not the website perfoming the request.
Otherwise, the phishing site could simply fake the domain and send the domain of
the page for which it is currently running the phishing attack.

Due to these two levels of security, your device will not even prompt you (e.g.
by flashing) for a confirmation interaction because it will reject all login
attempts beforehand.

At this point each phishing attempt will fail. Human error is now prevented due
to a simple check if the domain is the right on.

### Technical

Please consider the previous example. The way to start an interaction with the
authenticator via CTAP is defined by the WebAuthn javascript API. The following
javascript shows how to authenticate a user:

```js
let credential = await navigator.credentials.get({
  publicKey: {
    challenge: new Uint8Array([139, 66, 181, 87, 7, 203, ...]),
    rpId: "acme.com",
    allowCredentials: [{
      type: "public-key",
      id: new Uint8Array([64, 66, 25, 78, 168, 226, 174, ...])
    }],
    userVerification: "required",
  }
});
```

The example is straight from
[mozilla's Web Authentication API](https://developer.mozilla.org/en-US/docs/Web/API/Web_Authentication_API#authenticating_a_user)
and shows the API `navigator.credentials.get` to authenticate a user via a
challenge response and without providing the domain, just the `rpId`. As already
mentioned, the domain is added by the browser, when handling the CTAP request.

## What happens when someone steals my key?

Good question. Then you are still safe because I didn't tell you everything.
FIDO2 and the protocol where its based on (CTAP2), aims to make old stinky
password, as well as 2FA obsolete by providing a solution for both.

When you bought or setup our FIDO2 device, there are several options for
protecting your valuable private keys. FIDO2 sticks usually come with a support
for a PIN or with a biometrical sensor (e.g. fingerprint). The same goes for
your smartphone. The secure chip within your phone is often protected by a PIN,
a fingerprint or face recognition, or by a pattern you have to draw.

This way your FIDO2 matches the both important criteria for a secure
authentication: you know something (e.g. the PIN) and you have something (the
stick). Only one of both is not sufficient.

I like to think of the FIDO2 device of the universal bank card to your private
key vault.

## But what happens when I lose my key?

Also a good question. Be prepared. Or do you only have one key for your house,
your flat, or your car? No, you have a spare one.

Services that provide a password-less login via WebAuthn/ FIDO2, support the
ability to add multiple passkeys. You can add your main key that you use all day
long, as well as a secure spare key, that is always stored in a secure place at
your home. And if you're completely paranoid, you can add a third passkey to
your services and store the key at a different location, e.g. at your parents
house or at your bank.

Or in case you are a business, just give your responsible colleagues a spare key
so when one looses their key, the other one have a spare one.

Also important, services provide you often something called "recovery codes".
These are single-use recovery tokens, that you can use to unlock your account
after a lose of all your keys. Its probably a good idea to (print and) store
these at a different location instead of buying a dozen keys to be secure. But
that's the good thing, you have plenty of options to face a possible lose of
your device, so you can easily make use of this.

But also a warning: when you ignore all these options and only use your single
FIDO2 device without a fallback, your service provider probably want be able
to help you. Your account is then lost and you have to create a new one.

## FIDO2, the underrated technology of the future is already here

I hope you realised the huge potential and enormous security boost of FIDO2
and its ability for a password-less login. Its available. Right now, and its not
even expansive.

FIDO2 is an open standard and its implemented in various ways. There is the big
player [yubico with its yubikeys](https://www.yubico.com/) (no ad and no
affiliate link) and the wide array of tools for managing their devices. But
their are also many others like
[the German, open source FIDO2 sticks from Nitro](https://www.nitrokey.com/)
(also no ad and no affiliate link) or the
[pretty affordable FIDO2 sticks from the south korean company TrustKey](https://www.trustkeysolutions.com/en/main.form)
(also no ad and no affiliate link). Another option is to use your modern phone
(or business phone from your company) due to the meanwhile implemented secure
chips that allow a so called "passkey" handling on your phone.

Their are plenty of options today, some are more expansive (yubikeys, approx.
60-70 euros), some have a reasonable price (TrustKey, approx. 25 euros) and some
are already shipped on your phone. And everyone should consider switching to
them because our old passwords stink.

Do you have any suggestions, improvements or questions on this topic? Then let's
[chat about it on Mastodon (@lukasrotermund@social.tchncs.de)](https://social.tchncs.de/@lukasrotermund),
or just write me an email to
[lukas.rotermund+fido2\[at\]live.de](mailto:lukas.rotermund+fido2@live.de)!

Give FIDO2 a chance and at least try it out. Its so easy and you will never look
back at old stinky passwords and 2FAs like TOTPs.

1. You just open your password-less service
2. It already recognises your device and ask you if you want to use it to
authenticate yourself
3. Enter your PIN, or present your fingerprint or face to unlock the FIDO2
device
4. And voilà, you're signed in. No username, no password, just the quick
interaction with your device

## Sources

- [oneidentity - What is FIDO authentication](https://www.oneidentity.com/learn/what-is-fido-authentication.aspx)
- FIDO2/WEBAUTHN AND CTAP2 OVERVIEW via [Researchgate - How many FIDO protocols
are needed? Surveying the design, security and market perspectives](https://www.researchgate.net/publication/353055814_How_many_FIDO_protocols_are_needed_Surveying_the_design_security_and_market_perspectives)
- [CTAP - Client to authenticator protocol](https://fidoalliance.org/specs/fido-v2.0-id-20180227/fido-client-to-authenticator-protocol-v2.0-id-20180227.html)
- [W3C WebAuthn Recommendation](https://www.w3.org/TR/webauthn-2/)
