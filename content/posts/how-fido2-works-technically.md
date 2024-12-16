---
type: post
title: "How FIDO2 works technically"
tags: ["fido2", "security", "yubikey", "passkey"]
date: 2024-12-16T13:51:09+02:00
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

In this article I will explain how FIDO2, an open standard, works and how it is
commonly implemented using physical security keys in the form of USB A or C
sticks or just your smartphone.

We will explore what FIDO2 is and look at the mechanisms by which FIDO2 devices
protect their users against the threat of phishing attacks. I will try to
explain the topic to both non-technical and technical users. This is really
important to me because of the high security level of the devices, their ease of
use - especially for non-technical end users - and their now low price.

FIDO2 devices offer many advantages over "classic" multi-factor authenticators
such as Google's or Microsoft's time-based one-time password (TOTP)
authenticators. If my description is still too technical for you, please don't
hesitate to let me know where I can improve my explanations to reach more
people.

{{< toc >}}

## FIDO2, a brief introduction

FIDO2 is an open standard developed by the FIDO (Fast Identity Online) Alliance.
The alliance has many companies working together to create a new and secure way
of authenticating by building several open standards, not just FIDO2. Google,
Apple, Microsoft and Amazon are major partners in the alliance, to name but a
few.

One of the goals of the FIDO2 standard and the Alliance is to make passwords
obsolete. We have relied on passwords for so many years that we know they are
the opposite of secure. That's one reason why we use password vaults and
services to store a new secret for every service or website we sign up to.

A password is a secret, and we send the secret to someone else, trusting that
they will keep it safe. But they often don't. Passwords and user data are
breached every day. And users are human. They recycle passwords over and over
again.

As a rule of thumb, passwords are stored as "hashes" on the servers of the
website we are registering for. A "hash" is a reproducible product of an
algorithm, a one-way street, so the password is not stored on the servers in
clear, readable text, but the hash is. In this way, the service can re-hash the
password we send each time we log in, and all they have to do is compare the
hashes, the products of the algorithm.

It is unlikely, but not impossible, that these hashes can be converted back to
plain text and made readable again. In fact, if the service we give our secret
to uses a weak hashing algorithm like the broken MD5, it is very likely that our
password can be converted back to plain text. And even if not, given enough time
and computing power, any stolen password hash is likely to be insecure.

But there is a solution. A better way to express trust and authenticate to a
website. Better than sharing an (often) shared "secret". This is where things
get unsexy for non-technical readers - the solution is called asymmetric
encryption.

We all use it every day, some more consciously than others, but we all use it.
For example, when you visit my website. I force you as a visitor to visit my
site with encryption, TLS to be precise. If you visit <span
style="white-space:nowrap;">**http**://lukasrotermund.de</span>,
the unencrypted version of my website, I redirect you to
<span style="white-space:nowrap;">**https**://lukasrotermund.de</span>, the
encrypted version, as every website should do
these days.

You can compare asymmetric encryption with real-world keys. In asymmetric
encryption, there are two matching keys, a private key that is meant to be kept
private and a public key that is meant to be shared publicly. Each of these keys
can "lock" (encrypt a message/text), but the same key cannot open it, only its
counterpart can.

Think of a website: when you, as a visitor, type **https://lukasrotermund.de**
into your browser's address bar, your browser generates a new shared key that is
used for private communication between your browser and my website. To send me
your shared key, your browser sends a request (a lock) to my server and locks
(encrypts) it with my website's public key. Everyone on the internet is able to
get my website's public key, but only my server is able to unlock the request
you sent through the internet, from someone else's untrusted server to someone
else's untrusted server, until it reaches my website's server.

Now only my server can unlock the lock (the encrypted request) with its unshared
private key. And now that my server knows the key generated by your browser, it
can send you all the HTML files you request, locked (encrypted) with our secret
shared key that only our browser and my server know.

FIDO2 uses a similar method to verify that we are the user we say we are. Not
the same flow, but the same asymmetric encryption and separation of private and
public keys. This way we only have to share our public key instead of a secret.
And if hackers gain access to our public key, e.g. by hacking the website's
server/database, we are still safe and can sleep well.

## How FIDO2 uses asymmetrical encryption

### Non-technical

The previous example focused more on encryption, but FIDO2 uses asymmetric
encryption for something called **signing**. If my server knows you and your
public key (due to a registration process) and you try to log in to my website,
I can send you a randomly generated text as a challenge so that you can verify
that you are who you say you are.

If you, or rather your FIDO2 "device", is able to encrypt/lock (sign) the
message I send you, and I am able to decrypt/unlock the encrypted/locked text
with your public key you gave me, while your registration and the decryption
result also match the text I expect, then you have just proven to me that you
are in possession of the private counterpart key I expect you to have.

That's it, roughly speaking. That's the magic behind the new password and
secret-less authentication. Just a simple encryption and decryption process to
prove that you are the right person.

Of course, FIDO2 can do more, but we'll look at that later.

### Technical

FIDO2 is not a single thing, it is based on a protocol and a standard. CTAP
(Client to Authenticator Protocol) is the protocol, and WebAuthn (Web
Authentication) is the W3C standard. CTAP is responsible for the communication
between the client, e.g. a browser or operating system, and the authenticator
(e.g. a hardware device or secure chips in laptops or smartphones).

WebAuthn as a standard, on the other hand, defines the communication between the
browser and the service (server), also called the relying party, or RP for
short. It provides a Javascript API for the client to communicate with the
authenticator via CTAP and defines the communication with the RP and everything
beyond, such as certificate storage, challenge generation or HTTPS as the
transport protocol between the client and the RP.

The process behind FIDO2 is similar to a passwordless, key-based SSH login to a
server. SSH also uses a challenge-response process to authenticate users.
Applied to FIDO2, the authentication device holds the private keys securely,
immutably and unreadably, and the generated public key is stored on the RP
side. Disclaimer, yes it's possible to destroy the device and open its case to
read the private keys, but then the device is broken and can no longer be used
with CTAP.

For the challenge-response process, the RP generates a cryptographically secure,
random and unique BLOB in a secure and controlled environment. The BLOB is
typically a byte array of 16 or 32 bytes in length and its Base64URL encoded.
In addition to the challenge, the RP must store an expiration timestamp and
information about whether the challenge has already been used.

The generated challenge can now be shared with the client, which then launches a
CTAP via the WebAuthn API (js). The authenticator can now sign the challenge
after the user has authorised it by touching the device, scanning the correct
fingerprint or presenting the correct face. All the signing, CTAP handling and
key-related stuff is done inside the device, that's important to understand.
Your private keys never leave the device. The signed challenge is now sent back
to the RP who can now verify the signed challenge with the known public key.

## Why does FIDO2 mitigates phishing

OK, so now we know how FIDO2 uses asymmetric encryption to make old stinky
passwords (OSPs) obsolete. But how does this protect us from phishing, and why
is my OSP combined with my 2FA time-based one-time password (TOTP) not secure
enough?

The key factor is human. If a bad actor tries to break into my company by
creating a perfect looking phishing site and sending it to my employee, we now
have to rely on the human sitting in front of their computer to detect the
attack.

This sounds trivial, but in times of good LLMs (large language models, e.g.
ChatGPT, and many more) these attacks are written in a perfect language without
the old, classic mistakes. And if the malicious attacker is professional enough,
like a state-sponsored APT (Advanced Persistent Threat), a stealthy threat
actor, he has enough resources and time to prepare perfect phishing attacks.

By the way, if you are interested in protecting yourself against these APTs and
adversaries, have a look at my previous blog post
**[Cybersecurity introduction and the MITRE ATT&CK framework]({{< ref "cybersecurity-introduction-and-the-mitre-att&ck-framework" >}})**
to get your foot in the door.

Back to the phishing attack. Our employee clicks on the link to the phishing
site, e.g. a clone of the company's SaaS HR software where employees can manage
their leave requests or view their shifts, and the employee has no distrust of
the site. Then they navigate to login, enter their credentials and are prompted
to enter a 2FA TOTP.

For the attacker, it is now a matter of milliseconds to use the information
provided to take control of the account by providing it to the real SaaS
application and then changing the 2FA to their own.

People make mistakes, and that is OK, we just need to remember that when we
think about hardening security against malicious threat actors - especially in
times of hybrid warfare with aggressive countries like Russia and, not
infrequently, China. But it can also be between competing companies or from
unfriendly ex-employees.

So how does FIDO2 help us? Let's have a look!

### Non-technical

We've already learned that with FIDO2 there is communication between the service
I want to log in to and my FIDO2 device/authenticator. But isn't it possible
that a phishing site sends the request from the browser to my FIDO2 device and
steals my account with this request?

A clear no. This is not possible for a number of technical reasons. Firstly,
your FIDO2 device checks the domain of each incoming request and only performs
challenge signing for known domains. And your FIDO2 device is not all alone in
protecting your login, it also has the help of your browser.

The browser has an interface for the website to provide the ability for a
passwordless login called WebAuthn. WebAuthn is the one that adds the domain to
the request to your FIDO2 device, not the website making the request. Otherwise,
the phishing site could simply spoof the domain and send the domain of the site
they are phishing for.

Because of these two layers of security, your device will not even prompt you
(e.g. by flashing) for a confirmation interaction, as it will reject all login
attempts beforehand.

At this point, any phishing attempt will fail. Human error is now eliminated by
a simple check that the domain is the correct one.

### Technical

See the previous example. The way to start an interaction with the authenticator
via CTAP is defined by the WebAuthn Javascript API. The following javascript
shows how to authenticate a user:

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
[Mozilla's Web Authentication API](https://developer.mozilla.org/en-US/docs/Web/API/Web_Authentication_API#authenticating_a_user)
and shows the `navigator.credentials.get` API to authenticate a user via a
challenge response and without providing the domain, just the `rpId`. As
mentioned above, the domain is added by the browser when processing the CTAP
request.

## What happens when someone steals my key?

Good question. Then you're still safe because I haven't told you everything.
FIDO2 and the protocol it is based on (CTAP2) aim to make the old stinky
password and 2FA obsolete by providing a solution for both.

When you buy or set up our FIDO2 device, there are several ways to protect your
valuable private keys. FIDO2 sticks usually come with support for a PIN or with
a biometric sensor (e.g. fingerprint). The same goes for your smartphone. The
secure chip in your phone is often protected by a PIN, a fingerprint or facial
recognition, or a pattern you have to draw.

In this way, your FIDO2 meets the two most important criteria for secure
authentication: you know something (e.g. the PIN) and you have something (the
stick). Either one alone is not enough.

I like to think of the FIDO2 device as a universal key for all my password
vaults, just as there could be a universal bank card for all bank vaults.

## But what happens when I lose my key?

Also a good question. Be prepared. Or do you only have one key to your house,
apartment or car? No, you have a spare.

Services that offer passwordless login via WebAuthn/FIDO2 support the ability to
add multiple passkeys. You can add your main key that you use all day, plus a
secure spare key that is always kept in a safe place in your home. And if you're
really paranoid, you can add a third passkey to your services and keep it
somewhere else, like your parents' house or your bank.

Or, if you run a business, give your responsible colleagues a spare key so that
if one of them loses theirs, the others have a spare.

It is also important to note that services often provide you with something
called "recovery codes". These are one-time recovery tokens that you can use to
unlock your account if you lose all your keys. It is probably a good idea to
print these out and keep them somewhere, rather than buying a dozen keys to be
on the safe side. But that's the good thing, you have plenty of options if you
lose your device, so it's easy to use.

But a word of warning: if you ignore all these options and just use your single
FIDO2 device without a fallback, your service provider probably won't to be able
to help you. Your account will then be lost and you will have to create a new
one.

## FIDO2, the underrated technology of the future is already here

I hope you have realised the huge potential and security benefits of FIDO2 and
its ability to enable password-free login. It is available. Right now, and its
not even expansive.

FIDO2 is an open standard and is being implemented in a number of ways. There is
the big player [yubico with their yubikeys](https://www.yubico.com/) (not an ad
and not an affiliate link) and the wide range of tools to manage their devices.
But there are also many others, such as [the German open source FIDO2 sticks
from Nitro](https://www.nitrokey.com/) (also not an ad and not an affiliate
link) or the rather [affordable FIDO2 sticks from the South Korean company
TrustKey](https://www.trustkeysolutions.com/en/main.form) (also not an ad and
not an affiliate link). Another option is to use your modern mobile phone (or
your company's work phone), which now has secure chips that allow you to use a
passkey on your phone.

There are plenty of options now, some are more comprehensive (yubikeys, around
60-70 euros), some are cheap (TrustKey, around 25 euros) and some come on your
phone. And everyone should consider switching to them, because our old passwords
stink.

Do you have any suggestions, improvements or questions? Then let's [chat about
it on Mastodon
(@lukasrotermund@social.tchncs.de)](https://social.tchncs.de/@lukasrotermund) or
just drop me an email at
[lukas.rotermund+fido2\[at\]live.de](mailto:lukas.rotermund+fido2@live.de)!

Give FIDO2 a chance and at least give it a try. It is so easy and you will never
look back at old stinky passwords and 2FAs like TOTPs.

1. You simply open your passwordless service.
2. It already recognises your device and asks you if you want to use it to
authenticate yourself.
3. Enter your PIN or present your fingerprint or face to unlock the FIDO2
device.
4. And voilà, you're logged in. No username, no password, just quick
interaction with your device.

## Sources

- [oneidentity - What is FIDO authentication](https://www.oneidentity.com/learn/what-is-fido-authentication.aspx)
- FIDO2/WEBAUTHN AND CTAP2 OVERVIEW via [Researchgate - How many FIDO protocols
are needed? Surveying the design, security and market perspectives](https://www.researchgate.net/publication/353055814_How_many_FIDO_protocols_are_needed_Surveying_the_design_security_and_market_perspectives)
- [CTAP - Client to authenticator protocol](https://fidoalliance.org/specs/fido-v2.0-id-20180227/fido-client-to-authenticator-protocol-v2.0-id-20180227.html)
- [W3C WebAuthn Recommendation](https://www.w3.org/TR/webauthn-2/)
