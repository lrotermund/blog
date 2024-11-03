---
type: post
title: "Cybersecurity introduction and the MITRE ATT&CK framework"
tags: ["security", "cybersecurity", "mitre", "mitre att&ck", "hackumenta", "hackumenta2024"]
date: 2024-11-03T10:25:05+02:00
images: ["/assets/pexels-golnar-sabzpoush-rashidi-1317651-2530334.webp"]
image_alt: |
    The image shows a dark, deserted office corridor. The viewer is standing in
    the dark. The corridor is very dimly lit by hidden lights under a suspended
    ceiling. The image is intended to convey a gloomy, oppressive mood, but
    otherwise it plays no major role in the content of the blog post.
description: |
    Adversary countries have already positioned themselves for hybrid warfare.
    Use the MITRE ATT&CK framework to prepare for potential attack vectors.
summary: |
    Adversary countries have already positioned themselves for hybrid warfare.
    Use the MITRE ATT&CK framework to prepare for potential attack vectors.
toc: false
draft: false
---

The question is not whether you or your organisation will be hacked, but how
prepared you are and how you react. This post is an introduction to the big
rabbit hole cybersecurity and a big part of the introduction leads us to **the
pyramid of pain** and to the **MITRE ATT&CK framework**.

{{< toc >}}

## Foreword

I am myself a cybersecurity newbie. This post is a summery of what I learned
during the hackumenta, a hacking conference of my local hackspace flipdot
associated with the German chaos computer club, short CCC. So, please don't
expect perfect definitions, domain specific language and educated guesses. This
is a true view of a cybersecurity beginner on the topic.

Sadly due to the nature of the framework we'll look at, this post is not as
accessible as the rest of my posts. The framework uses a lot of visual elements
and big tables to show sensible attack vectors that I cannot represent well
accessible. I'll try to explain all the relevant information within the alt
texts of the included screenshots, but there will be definitively a loss in
information for which I am really sorry.

## The basics

If your common with cybersecurity basics and just want to learn something about
the MITRE ATT&CK framework you can easily skip the fist sections, there will be
hardly anything new for you.

### "But my software developers are writing secure code, so why should I care?"

A common mistake in software development is, that software developers write
automatically secure and safe code and that cybersecurity is just something
that big companies with a couple thousand employees have to care about.

(Cyber-) security is a so called **non functional requirement** which I could
and should write a couple of posts about. Here is a simplified view on the
topic:

Software developers usually only get the opposite within their tasks,
**functional requirements**. Examples are:

- "Show cross selling articles on the checkout"
- "Send a timer on articles in sale"
- "A visitor should be able to order as a guest"

But there won't be requirements like:

- "A visitors session is stored in a http-only cookie"
- "The firewall logs must not be deleted easily to avoid loss of evidence after
an attack"
- "The payment at the end of the checkout should take five seconds tops"

The problem with non functional requirements are, that broadly spoken
"customers" do not think about them or only when they become a problem. There is
no business value associated with non functional requirements. So there is no
interest in enunciating them.

And to be fair, its IMO not the responsibility of the "customers" to know and
care about them. Its the responsibility of us, software developers and (cyber-)
security specialists to know about them and to consider them when planning the
tasks.

**TL;DR** No, your software developers don't write secure code automatically,
only when they know about non functional requirements or when you enunciate
them. Because neither is the rule, but rather an exception, you should and have
to care.

### 🙈 🙉 🙊 "It won't happen to us, what could they possibly steal?"

Its not my goal to play with fear as a rhetorical device. But its also not OK
to ignore the risks of a cyberattack, especially today. They occur on a daily
basis and from a lot of aggressors. Hostile countries like Russia, Iran or
North Korea, as well as unfriendly countries like China (to just name a few) are
already supporting, enabling, instructing, and operating different kind of
hacker groups with western targets - the keyword here is: hybrid warfare.

If I collect personal information as a business or private person, I owe it to
my visitors, users and customers to keep it secure, to use it only in ways that
are relevant, to delete it when I no longer need it, and to notify and
compensate them in the event of a data breach.

Anyone can be a target for hacker groups, not just the big fish. In fact, the
smaller fish are often the best targets. There is usually no good cybersecurity
knowledge, software and security mechanisms are likely to be outdated, and there
will be no routines when it comes to an attack. Easy targets and often also easy
money.

Additionally its likely that the victims of a cyberattack will act in favor for
the attacks after the attack has happened. Many organisations, out of confusion,
fear and lack of routine, simply reset all systems to get rid of hackers. Files
get removed and logs deleted. But exactly that helps the attackers due to a loss
of evidence.

### Just be prepared

Cybersecurity is a bottomless topic and attackers are always a dozen steps ahead
of possible victims. It is easier for them because they just have to be prepared
for a couple scenarios and attack vectors and the defenders have to be prepared
for all possible scenarios. But is this correct?

Think of an intruder as the hacker group in the following example. The intruder
goes through a well prepared routine when breaking into houses. They maybe start
by a rough preselection of houses by attributes like availability of hiding
places, lightning, chance to escape in case of detection and of course the
quality of loot.

Next they start with the first house and try to break into the first window. But
the window is to good protected and it would take to much time to get in, so
they go to the next window. Now a big light turns on due to a motion sensor. As
a result they will just skip your house and go to your neighbour, because you
knew the typical attack vectors for intruders.

At the next house they open the first window and are in. Now they are looking
for loot, but there is no loot on the ground floor and the second floor is
locked with door. But they are window-intruders, they are not prepared to open
doors, so they leave and go to the next house because sooner or later there will
be a house where someone is not prepared.

Hacker groups and intruders have often some things in common. They are secure
with a couple of tools and within their routine and it is their goal to go in
quickly, do want they planned to do and then to leave as quickly as they got in.

If some things are going wrong and they have to leave their routine to achieve
a goal, or if something takes to much time and they risk to get caught, they
stop and leave, or they don't even see you as a potential target.

Don't be the easy neighbour. Be prepared.

## The pyramid of pain

The windows and doors of the previous example can be translated to the digital
world. We have a couple of "protection" layers that we rely on to protect our
software, our infrastructure. These layers can be represented within the so
called pyramid of pain from David Bianco. The pain describes how hard it is for
the attackers to hack into our system.

{{< _figureCupper
img="the-pyramid-of-pain.webp" 
alt="The picture shows 'the pyramid of pain' with its six layers from top to bottom: 1. 'TTPs - Tought!', 2. 'Tool - Challenging', 3. 'Network/ Host Artefacts - Annoying', 4. 'Domain Names - Simple', 5. 'IP Address - Easy', 6. 'Hashes - Trivial'"
caption="Custom drawing of David Bianco's 'The pyramid of pain'. I know, my drawing skills are 'impressive'..."
command="Original"
lazy="true" >}}

The bottom of the pyramid is hashes, because its pretty trivial for hackers to
modify hashes we rely on. Also, we cannot know all possible hashes to be
prepared against wrong ones.

The next layer is the IP address, because its easy for hackers to fake, modify
and change their IP address. So its not a recommended protection.

Domain names on layer four is still simple. Its often easy for hackers to buy a
equal looking domain to prepare their attacks, e.g. instead of
**lukasrotermund.de** they just buy **iukasrotermund.de**. Depending on the font
and the zoom its hard to see a difference.

Its getting harder for hacker from layer three. Now they have to manipulate our
network or host artefacts. They have to hide their paths in our network where
they can easy leave evidence in logs. But for specialised hacker groups its
easy but annoying to work here.

In layer five they have to manipulate and or exchange the tools our company is
using. That is challenging even for skilled hackers, but with enough time and
experience not impossible.

The last layer is the toughest. The abbreviation TTPs stands for "Tactics,
Techniques & Procedures". Within this stage, the hackers are trying to change
and hack our company internal processes. Everything they do here, starting from
attacks like spear fishing, where they could read the email traffic of the HR
department for example and therefore know secret internals of employees like
urgent wishes for vacation. Now they could use that against the employees in the
name of HR to escalate their privileges. They could also have the goal of
persistence (keeping a foot in the door) and very often to exfiltrate data.

The biggest benefit of the defenders is here, that the barriers are higher then
in all the other layers. When something doesn't work as expected, the hackers
have a higher risk to get caught and cancel there operation quickly to train
executing hackers again, or to search for other attack vectors.

And that's where the second part of the post gets important, the MITRE ATT&CK
framework.the
in all the other layers. When something doesn't work as expected, the hackers
have a higher risk to get caught and cancel there operation quickly to train
executing hackers again, or to search for other attack vectors.

And that's where the second part of the post gets important, the MITRE ATT&CK
framework.

## The MITRE ATT&CK framework

The word MITRE has two parts, MIT and RE. MIT is the Massachusetts Institute of
Technology and RE means Research Establishment. The MIT has is background in
the US military, but not so the MITRE. Its a non-profit organisation working for
and with their community and with the US government.

And this organisation provides the ATT&CK framework which targets exactly the
TTPs from the previous section. Its means Adversarial Tactics, Techniques and
Common Knowledge and it is a publicly available, global tool that helps security
experts and companies to prepare and protect themself better against this kind
of attack vectors.

The framework provides a big matrix with the hacker's tactics as headers and the
techniques of the tactics as columns. Every technique occurs only once under one
tactic and the tactics are sorted by the attack phase, starting with the
reconnaissance and ending with the exfiltration and the impact.

{{< _figureCupper
img="mitre-att-and-ck-matrix.webp" 
imgLink="https://attack.mitre.org/"
alt="The picture shows a screenshot of the MITRE ATT&CK website with the partially visible matrix. The visible part of the matrix has the headers: Reconnaissance, Resource Development, Initial Access, Execution, Persistance, Privilege Escalation and Defense Evasion. Also visible are a few techniques of tactics like the following first row: Active Scanning, Acquire Access, Content Injection, Cloud Administration Command, Account Manipulation, Abuse Elevation Control Mechanism. There a many more rows visible. The screenshot has the goal to show the complexity of the matrix."
caption="Screenshot of the MITRE ATT&CK website, showing a part of the matrix."
command="Original"
lazy="true">}}

Its easy to get lost within all the tactics, techniques and their sub-techniques
especially as a beginner, when you have to deal with the new cyber security
domain language. This is exactly my current state. But there is light at the end
of the tunnel. The MITRE organisation is not only providing this big matrix, but
also a great angular tool called **[ATT&CK® Navigator](https://github.com/mitre-attack/attack-navigator)**
that you can find on GitHub.

But before you start using the ATT&CK® Navigator, try to explore the framework
a little and make yourself comfortable with its architecture. I won't go into
details here because I learned about the framework on the hackumenta a few days
ago, so I can't really help you here.

All I can tell you is, that the framework and everything it provides you
(tactics, techniques, groups, etc.) are based on real world data, provided by
companies, organisations and federal agencies. Every technique contains a
detailed description and some metadata, as well as procedure examples with real
hacker groups participated and the mitigations that helped to prevent the
hacker group from being successful.

The way the information is presented is impressive. Every relevant keyword is
well described and the mitigations are well organised in clean, structured
tables. Nothing is overloaded with information, when you leave the matrix.

And what helps me the most is, that the path from the root (matrix) to the
techniques is not shared and cross linked with other tactics. Its like a well
organised tree of information.

## The MITRE ATT&CK® Navigator

The ATT&CK® Navigator can be used in different ways, in the end its just an
angular SPA. A recommended way is to use a GitHub fork and to enable GitHub
Pages so you have your own GitHub page. But you can also use npm or you just use
docker and clone, build and run the container:

```sh
git clone git@github.com:mitre-attack/attack-navigator.git
cd attack-navigator
docker build -t attack-navigator .
docker run --detach -p 127.0.0.1:4200:4200 attack-navigator
```

Then you can open it in your browser under `127.0.0.1:4200`:

{{< _figureCupper
img="mitre-att-and-ck-navigator.webp" 
alt="The screenshot shows the front page of the MITRE ATT&CK® Navigator opened in the browser at '127.0.0.1:4200'. On the top part of the page there is a tab menu where multiple navigator layers could be opened at the same time, including a button to add another layer. Beneath is the default layer option where the user can choose between 1. 'Create New Layer', 2. 'Open Existing Layer', 3. 'Create Layer from Other Layers' and 4. 'Create Customized Navigator'."
caption="Screenshot of the MITRE ATT&CK® Navigator's front page."
command="Original"
lazy="true">}}

### Analysing attack vectors for the finance industry using the ATT&CK® Navigator

My goal with this section is to enable you also to get a foot in the
cybersecurity-door. I will show you a way, how you can use the navigator with a
practically example so you are not longer overwhelmed by all the possible
options of the matrix.

But there is also a big problem with the MITRE ATT&CK® Navigator that I will
share with you. If I have found a solution in the future, the will be a hint in
this section to.

Let's start with the analysis. We are now working together in the IT security/
software development/ Dev(Sec)Ops department of our finance company and its our
goal to find possible attack vectors of adversaries against our company.

Now we open the freshly started ATT&CK® Navigator and choose **Create New
Layer**, and then of course **Enterprise ATT&CK**. The navigator starts now
loading the latest version MITRE ATT&CK matrix, in my case that's 16.

On our new "Layer 1" we start by clicking on the **Selection Controls** which
reveals a sidebar with a search field on the top. Because we are looking for
attack vectors for the finance industry, we are now entering **finance** into
the search field to search for adversaries/ groups that have been associated or
are known for attacking this industry. The search looks within the "name",
"ATT&CK ID", "description" and "data source" of the MITRE ATT&CK framework for
our keyword.

In my case the navigator found the four adversaries **APT19**, **APT41**,
**menuPass** and **Moses Staff**. APT19 is a Chinese-based thread group, APT41
is a Chinese state-sponsored espionage group and menuPass is a thread group
where individual members are acted in association with the Chinese Ministry of
State Security's (MSS). The last group Moses Staff is an Iranian thread group
that primarily targets Israeli companies. All these groups have in common, that
they attack the finance industry occasionally. You can find all these
information within the MITRE ATT&CK framework by just clicking on "view", next
to the search result.

{{< _figureCupper
img="mitre-att-and-ck-navigator-search.webp" 
alt="The screenshot shows the unchanged first layer with an open 'Selection Controls' sidebar. The search field contains the word 'finance' and the 'Thread Groups' results section show the four results 'APT19', 'APT41', 'menuPass' and 'Moses Staff'"
caption="Screenshot of the **Thread Groups** search result showing the four adversary groups **APT19**, **APT41**, **menuPass** and **Moses Staff**."
command="Original"
lazy="true">}}

Now we have four interesting research targets for potential attack vectors
against our company. Within the next step, we will prepare our first layer to
analyse tactics and techniques of the first group, APT19.

Click on the **select** button to select all techniques of APT19. Now switch
from the **Selection Controls** to the **Layer Controls** and change the name
within the **layer settings** from "Layer 1" to "APT19". Next open the **color
setup** menu to switch the color palette to the preset **transparent to red**.
Because we are analysing four groups, set the **High value** to "4". To apply
the color palette go now to the last menu **Technique Controls** and set a "1"
as the score in the **scoring** option.

Your layer should now look like this:

{{< _figureCupper
img="mitre-att-and-ck-navigator-apt19.webp" 
alt="The screenshot shows the blank view on the MITRE ATT&CK matrix again, but this time the techniques of the APT19 thread group have a red background color. Highlighted are the techniques 'Drive-by Compromise' (tactic: Initial Access), 'Command and Scripting Interpreter' (tactic: Execution) and 'Deobfuscate/ Decode Files or Information' (tactic: Defense Evasion)'"
caption="Screenshot of the APT19 layer set up, showing their usual techniques with a red background."
command="Original"
lazy="true">}}

Within the screenshot we can now see the techniques, that the thread group APT19
used in the past to attack targets in the finance industry. This is already an
helpful information. But we can do better. Repeat the steps of the APT19 group
now for the three other adversaries APT41, menuPass and Moses Staff, each on its
own layer.

When finished, create a new layer by clicking on **Create Layer from Other
Layers**. Next select the latest ENTERPRISE ATT&CK version as a domain. To merge
the other layers scores, set the **score expression** to `a+b+c+d`. To finish
the set up, select the **gradient** and **coloring** from any other layer, e.g.
APT19. Here is a screenshot of the settings I configured:

{{< _figureCupper
img="mitre-att-and-ck-navigator-merging-layers.webp" 
alt="The screenshot shows the filled out input fields, described in the previous paragraph, including the domain 'ENTERPRISE ATT&CK v16', the score expression 'a+b+c+d', the gradient and coloring from the layer 'APT19'."
caption="Screenshot of the **Create Layer from Other Layers** form set up to create the adversaries layer."
command="Original"
lazy="true">}}

Now create the new layer and rename it in the **Layer Controls** to
"Adversaries". The previously set up gradient and the scores range from 0-4
enables us now to see the shared techniques of our thread groups. This is where
you start, this is your foot in the door. You don't need to focus on every
single technique in the framework, just start by looking at the most important
ones. After that focus on the are less or not overlapping.

In the following screenshot (or in your own navigator) you can see, that the we
have the overlapping technique **System Network Configuration Discovery** of the
tactic **Discovery** with a max score of four and next the following four with
a score of three:

- Exploit Public-Facing Application (tactic: Initial Access)
- Deobfuscate/ Decode Files or Information (tactic: Defense Evasion)
- System Information Discovery (tactic: Discovery)
- Ingress Tool Transfer (tactic: Command and Control)

Then we have have 13 overlapping techniques with a score of two:

- Valid Accounts (tactic: Initial Access)
- Windows Management Instrumentation (tactic: Execution)
- Valid Accounts (tactic: Persistence)
- Valid Accounts (tactic: Privilege Escalation)
- Modify Registry (tactic: Defense Evasion)
- Valid Accounts (tactic: Defense Evasion)
- File and Directory Discovery (tactic: Discovery)
- Network Service Discovery (tactic: Discovery)
- Remote System Discovery (tactic: Discovery)
- System Network Connections Discovery (tactic: Discovery)
- System Owner/ User Discovery (tactic: Discovery)
- Automated Collection (tactic: Collection)
- Data from Local System (tactic: Collection)

And finally a couple more with a score of one, so no overlapping between the
thread groups:

{{< _figureCupper
img="mitre-att-and-ck-navigator-adversaries.webp" 
alt="The screenshot shows the combined layer of adversaries, with a stronger color on the overlapping techniques 'Exploit Public-Facing Application' and 'Valid Accounts' (tactic: Initial Access) with the scores 3 and 2, 'Windows Management Instrumentation' (tactic: Execution) with a score of 2, 'Valid Accounts' (tactic: Privilege Escalation) with a score of 2, 'Deobfuscate/ Decode Files or Information' (tactic: Defense Evasion) with a score of 3, 'File and Directory Discovery' and 'Network Service Discovery' (tactic: Discovery) both with a score of 2, 'Automated Collection' and 'Data from Local System' (tactic: Collection) both also with a score of 2 and 'Ingress Tool Transfer' (tactic: Command and Control) with a score of 3."
caption="Screenshot of the matrix including the combined scores and highlighted techniques."
command="Original"
lazy="true">}}

### Mitigating attack vectors

Now there we know about the most used techniques to attack our example industry,
we can start by using the MITRE ATT&CK framework to lookup mitigations that we
can apply to mitigate the impact and/or success of the adversaries.

Starting with the [System Network Configuration Discovery](https://attack.mitre.org/techniques/T1016/),
there sadly no known mitigations because they are exploitable due to system
failure, as you can read at the techniques page in the framework. So lets skip
to [Exploit Public-Facing Application](https://attack.mitre.org/techniques/T1190/)
with a score of three.

This time we have a couple mitigations, for example [Application Isolation and Sandboxing](https://attack.mitre.org/mitigations/M1048/).
These mitigations are methods we can look up right away. We can go to our
(software) infrastructure and check if the mitigations are already applied or if
we have a todo.

{{< _figureCupper
img="mitre-att-and-ck-navigator-mitigation.webp" 
imgLink="https://attack.mitre.org/techniques/T1190/"
alt="The screenshot shows a table of the mitigations for the technique 'Exploit Public-Facing Applications'. The table contains the following mitigations: M1048 'Application Isolation and Sandboxing', M1050 'Exploit Protection', M1030 'Network Segmentation', M1026 'Privileged Account Management', M1051 'Update software' and M1016 'Vulnerability Scanning'. All these techniques are links, pointing to their mitigation site."
caption="Screenshot of the **Exploit Public-Facing Application** technique's mitigations."
command="Original"
lazy="true">}}

Let's say we already did this for all the overlapping techniques of the previous
section with a score of four and three. Our team was quick in checking and
implementing the MITRE ATT&CK mitigations.

Now we can add a new layer to the navigator for the techniques we have already
mitigated. This time we add a fresh new layer with the latest framework version
again. This time we name the layer "defense" and change the color palette to
the preset **transparent to blue** with the **High value** of "4".

Next we `CTRL` select all the mitigated adversary techniques with a score of
three and set there score in our defense layer to "4" too. And due to the non
mitigate ability of the **System Network Configuration Discovery** we set it's
score just to "1".

{{< _figureCupper
img="mitre-att-and-ck-navigator-defense.webp" 
alt="The screenshot shows the defense layer with the two visible, blue highlighted techniques 'Exploit Public-Facing Application' and 'Deobfuscate/ Decode Files or Information'. The other techniques have there default, grey background."
caption="Screenshot of the defense layer with two visible, blue highlighted techniques."
command="Original"
lazy="true">}}

OK, this is our defense starting point. The next step is to compare the
thread group techniques with our mitigated ones. To do that, add a new layer
again, this time we click on **Create Layer from Other Layers** again. As
before, we choose the latest ENTERPRISE ATT&CK version as the domain and last we
subtract the defense (f) from the adversaries (e), so set the score expression
to "e-f". And don't set a gradient or coloring this time, we choose another one
for the comparison.

{{< _figureCupper
img="mitre-att-and-ck-navigator-setup-current-state.webp" 
alt="The screenshot shows the filled out input fields, described in the previous paragraph, including the domain 'ENTERPRISE ATT&CK v16', the score expression 'e-f'."
caption="Screenshot of the **Create Layer from Other Layers** form set up to create the current state layer."
command="Original"
lazy="true">}}

After creating the layer, we change its name to "current state" in the **Layer
Controls**. Then we change the gradient score range to "0" as the **Low value**
and "2" as a **High value**. To improve the colors, select the preset **green
to red**, so the lower the score, the better we are protected against the
technique.

As a result you can see, that the techniques with a previous score of three do
now have a score of "-1" which makes them super green. This way we can see,
what we have accomplished by by our mitigation and where still work is to do.

{{< _figureCupper
img="mitre-att-and-ck-navigator-current-state.webp" 
alt="The screenshot shows the combined matrix of adversary scores and our defense scores. The mitigated techniques are displayed with a green background color, the low scored techniques are yellow and the overlapping, high scored techniques are still read."
caption="Screenshot of the combined matrix of adversaries and our defense positions."
command="Original"
lazy="true">}}

To not throw all your work in the garbage every time, you can also export all
your layers into a single JSON and import it later the same way. You will find
the export option in the **Layer Controls** under **export** write next to the
settings.

## The MITRE ATT&CK framework's major drawback.

Right now my biggest problem with the MITRE ATT&CK framework is its reduced
capability of filtering and finding thread groups based on a given industry. My
example just works for the big ones like finance, healthcare, military, etc.
I attended to use the industry 'e-commerce' where I'm currently working in as an
example for this post, but there is not a single thread group related to it in
the framework. So I had to pick a big industry like finance.

Actually that's my one and only problem right now. If you know about a good
adversaries/thread group-industry mapping, that is also compatible with the
MITRE ATT&CK adversaries, then please contact me on Mastodon
`@lukasrotermund@social.tchncs.de`. You will find an update here, when I have
found a good source for a better mapping.

## Some final thoughts

I like the MITRE ATT&CK framework and the Navigator very much. MITRE it's
community build something very impressive here. It's rich in information and the
navigator is a pretty simple to use tool. The framework provides a clear and
minimalistic structure but is also able to give a lot of structured information.

I would love to be able to use it a better way and to analyse attack vectors for
every industry, not only the big ones.
