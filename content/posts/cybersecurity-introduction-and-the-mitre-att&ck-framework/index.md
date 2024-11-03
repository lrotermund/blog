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
prepared you are and how you will react. This post is an introduction to the
great rabbit hole of cybersecurity, and much of the introduction leads us to
**the Pyramid of Pain** and the **MITRE ATT&CK Framework**.

{{< toc >}}

## Foreword

I am a cybersecurity newbie myself. This post is a summery of what I learned at
hackumenta, a hacking conference run by my local hackspace flipdot, which is
affiliated with the German Chaos Computer Club, or CCC for short. So please
don't expect perfect definitions, domain-specific language and educated guesses.
This is a cybersecurity beginner's view of the subject.

Unfortunately, due to the nature of the framework we'll be looking at, this post
is not as accessible as the rest of my posts. The framework uses a lot of
visuals and large tables to show meaningful attack vectors that I cannot present
in an accessible way. I'll try to explain all the relevant information in the
alt text of the screenshots included, but there will definitely be a loss of
information for which I'm very sorry.

## The basics

If you are familiar with the basics of cybersecurity and just want to learn
about the MITRE ATT&CK framework, you can skip the first few sections, there
will be little new for you.

### "But my software developers are writing secure code, so why should I care?"

A common misconception in software development is that software developers
automatically write safe and secure code, and that cybersecurity is just
something that big companies with a few thousand employees need to worry about.

(Cyber) security is a so-called **non-functional requirement**, about which I
could and should write a couple of posts. Here is a simplified view of the
subject:

Software developers usually only get the opposite within their tasks,
**functional requirements**. Examples are:

- "Show cross-selling items at checkout"
- "Send a timer on items on sale"
- "A visitor should be able to order as a guest".

But there won't be requirements such as

- "A visitor's session is stored in an http-only cookie".
- "The firewall logs must not be easily deleted to avoid loss of evidence after an attack".
- "Payment at the end of the checkout should take no more than five seconds".

The problem with non-functional requirements is that, broadly speaking,
"customers" do not think about them, or only think about them when they become a
problem. There is no business value associated with non-functional requirements.
So there is no interest in articulating them.

And to be fair, IMO, it is not the responsibility of "customers" to know and
care about them. It is the responsibility of us, the software developers and
(cyber) security specialists, to know about them and to take them into account
when planning the tasks.

**TL;DR** No, your software developers don't automatically write secure code,
only when they know about non-functional requirements or when you tell them to.
Since neither is the rule, but rather the exception, you should and must take
care of it.

### 🙈 🙉 🙊 "It won't happen to us, what could they possibly steal?"

It is not my aim to play with fear as a rhetorical device. But it is also not OK
to ignore the risks of a cyber attack, especially today. They happen every day
and from many different aggressors. Hostile countries like Russia, Iran or North
Korea, as well as unfriendly countries like China (to name but a few) are
already supporting, enabling, directing and operating various kinds of hacker
groups with Western targets - the keyword here is hybrid warfare.

If I collect personal information as a business or individual, I owe it to my
visitors, users and customers to keep it secure, to use it only in ways that are
relevant, to delete it when I no longer need it, and to notify and compensate
them in the event of a data breach.

Anyone can be a target for hacking groups, not just the big fish. In fact, the
smaller fish are often the best targets. There is usually no good cybersecurity
knowledge, software and security mechanisms are likely to be outdated, and there
will be no routines when it comes to an attack. Easy targets and often easy
money.

In addition, the victims of a cyber attack are likely to act in favour of the
attackers after the attack has taken place. Many organisations, out of
confusion, fear and lack of routine, simply reset all systems to get rid of the
hackers. Files are removed and logs deleted. But this actually helps the
attackers by eliminating evidence.

### Just be prepared

Cybersecurity is a never-ending story and attackers are always a dozen steps
ahead of potential victims. It is easier for them because they only have to be
prepared for a few scenarios and attack vectors, while defenders have to be
prepared for all possible scenarios. But is that right?

Consider an intruder as the hacker group in the following example. The intruder
goes through a well-prepared routine when breaking into houses. They may start
by roughly pre-selecting houses based on attributes such as the availability of
hiding places, lightning, the chance of escape if detected, and of course the
quality of the loot.

Next, they start with the first house and try to break into the first window.
But the window is too well protected and it would take too long to get in, so
they move on to the next window. Now a large light goes on because of a motion
sensor. As a result, they skip your house and go to your neighbour's, because
you know the typical attack vectors for intruders.

At the next house, they open the first window and get in. Now they are looking
for loot, but there is no loot on the ground floor, and the second floor is
locked with a door. But they are window intruders, they are not prepared to open
doors, so they leave and go to the next house, because sooner or later there
will be a house where someone is not prepared.

Hacker groups and intruders often have a few things in common. They are secure
with a few tools and in their routine, and their goal is to get in quickly, do
what they have planned, and then get out as quickly as they got in.

If something goes wrong and they have to leave their routine to achieve a goal,
or if something takes too long and they risk getting caught, they'll stop and
walk away, or they won't even see you as a potential target.

Don't be the easy neighbour. Be prepared.

## The pyramid of pain

The windows and doors of the previous example can be applied to the digital
world. We have a number of "layers of protection" that we rely on to protect our
software, our infrastructure. These layers can be represented by David Bianco's
pyramid of pain. The pain describes how difficult it is for attackers to break
into our system.

{{< _figureCupper
img="the-pyramid-of-pain.webp" 
alt="The picture shows 'the pyramid of pain' with its six layers from top to bottom: 1. 'TTPs - Tought!', 2. 'Tool - Challenging', 3. 'Network/ Host Artefacts - Annoying', 4. 'Domain Names - Simple', 5. 'IP Address - Easy', 6. 'Hashes - Trivial'"
caption="Custom drawing of David Bianco's 'The pyramid of pain'. I know, my drawing skills are 'impressive'..."
command="Original"
lazy="true" >}}

The bottom of the pyramid is hashes, because it is quite trivial for hackers to
change the hashes we rely on. Also, we cannot know all possible hashes to guard
against false ones.

The next level is the IP address, because it is easy for hackers to forge,
modify and change their IP address. So it is not a recommended protection.

Domain names at layer four are still simple. Its often easy for hackers to buy a
similar looking domain to prepare their attacks, e.g. instead of
**lukasrotermund.de** they just buy **iukasrotermund.de**. Depending on the font
and zoom, it is hard to tell the difference.

It gets harder for hackers on layer three. Now they have to manipulate our
network or host artefacts. They have to hide their paths in our network, where
they can easily leave evidence in logs. But for specialised hacker groups, this
is easy, but tedious.

At layer five, they need to manipulate and/or replace the tools our company
uses. This is a challenge even for skilled hackers, but not impossible with
enough time and experience.

The last layer is the hardest. The acronym TTPs stands for Tactics, Techniques &
Procedures. At this stage, the hackers try to change and hack our internal
processes. Everything they do here, starting with attacks like spear fishing,
where they could read the email traffic of the HR department, for example, and
therefore know secret internal things about employees, like urgent requests for
vacation. Now they could use that against employees in the name of HR to
escalate their privileges. They could also have the goal of persistence (keeping
a foot in the door) and very often to exfiltrate data.

The biggest advantage of the defenders here is that the barriers are higher than
in any of the other layers. If something doesn't work as expected, the
adversaries have a higher risk of being caught and will quickly abort the
operation to train new hackers or look for other attack vectors.

And that's where the second part of the post comes in, the MITRE ATT&CK
framework.

## The MITRE ATT&CK framework

The word MITRE has two parts, MIT and RE. MIT is the Massachusetts Institute of
Technology and RE means Research Establishment. The MIT has its background in
the US military, but not so the MITRE. It is a non-profit organisation that
works for and with its community and with the US government.

And this organisation provides the ATT&CK framework, which is aimed precisely at
the TTPs from the previous section. It stands for Adversarial Tactics,
Techniques and Common Knowledge and it is a publicly available, global tool to
help security professionals and companies better prepare and protect themselves
against these types of attack vectors.

The framework provides a large matrix with the hacker tactics as headers and the
techniques of the tactics as columns. Tactics are sorted by attack phase,
starting with reconnaissance and ending with exfiltration and impact.

{{< _figureCupper
img="mitre-att-and-ck-matrix.webp" 
imgLink="https://attack.mitre.org/"
alt="The picture shows a screenshot of the MITRE ATT&CK website with the partially visible matrix. The visible part of the matrix has the headers: Reconnaissance, Resource Development, Initial Access, Execution, Persistance, Privilege Escalation and Defense Evasion. Also visible are a few techniques of tactics like the following first row: Active Scanning, Acquire Access, Content Injection, Cloud Administration Command, Account Manipulation, Abuse Elevation Control Mechanism. There a many more rows visible. The screenshot has the goal to show the complexity of the matrix."
caption="Screenshot of the MITRE ATT&CK website, showing a part of the matrix."
command="Original"
lazy="true">}}


It is easy to get lost in all the tactics, techniques and their sub-techniques,
especially as a beginner when you have to deal with the new domain language of
cybersecurity. This is where I am at the moment. But there is light at the end
of the tunnel. The MITRE organisation not only provides this big matrix, but
also a great angular tool called the
**[ATT&CK® Navigator](https://github.com/mitre-attack/attack-navigator)**, which you
can find on GitHub.

But before you start using the ATT&CK® Navigator, try to explore the framework
a bit and get familiar with its architecture. I won't go into details here,
because I got to know the framework a few days ago at the hackumenta, so I can't
really help you here.

All I can tell you is that the framework and everything it provides (tactics,
techniques, groups, etc.) is based on real-world data provided by companies,
organisations and government agencies. Each technique includes a detailed
description and some metadata, as well as examples of what real hacker groups
have done, and the mitigations that helped prevent the hacker group from
succeeding.

The way the information is presented is impressive. Each relevant keyword is
well described and the mitigations are well organised in clean, structured
tables. Nothing is overloaded with information when you leave the matrix.

And what helps me the most is that the path from the root (matrix) to the
techniques is not shared and cross-linked with other tactics. It is like a well
organised tree of information.

## The MITRE ATT&CK® Navigator

The ATT&CK® Navigator can be used in a number of ways, it is after all just an
angular SPA. One recommended way is to use a GitHub fork and enable GitHub pages
so you have your own GitHub page. But you can also use npm or just use docker
and clone, build and run the container:

```sh
git clone git@github.com:mitre-attack/attack-navigator.git
cd attack-navigator
docker build -t attack-navigator .
docker run --detach -p 127.0.0.1:4200:4200 attack-navigator
```

You can then open it in your browser at `127.0.0.1:4200`:

{{< _figureCupper
img="mitre-att-and-ck-navigator.webp" 
alt="The screenshot shows the front page of the MITRE ATT&CK® Navigator opened in the browser at '127.0.0.1:4200'. On the top part of the page there is a tab menu where multiple navigator layers could be opened at the same time, including a button to add another layer. Beneath is the default layer option where the user can choose between 1. 'Create New Layer', 2. 'Open Existing Layer', 3. 'Create Layer from Other Layers' and 4. 'Create Customized Navigator'."
caption="Screenshot of the MITRE ATT&CK® Navigator's front page."
command="Original"
lazy="true">}}

### Analysing attack vectors for the finance industry using the ATT&CK® Navigator

My aim in this section is to enable you to get a foot in the door of
cybersecurity. I will show you a way to use the Navigator with a practical
example so that you are no longer overwhelmed by all the possible options of the
matrix.

Let's start with the analysis. We are now working together in the IT Security/
Software Development/ Dev(Sec)Ops department of our financial company and our
goal is to find possible attack vectors of adversaries against our company.

Now we open the freshly launched ATT&CK® Navigator and select **Create New
Layer** and then, of course, **Enterprise ATT&CK**. The Navigator now starts to
load the latest version of the MITRE ATT&CK matrix, in my case it's version 16.

On our new 'Layer 1', we start by clicking on the **Selection Controls**, which
brings up a sidebar with a search field at the top. As we are looking for attack
vectors for the financial industry, we now type **finance** into the search
field to look for adversaries/groups that are associated with or known to attack
this industry. The search looks for our keyword within the "name", "ATT&CK ID",
"description" and "data source" of the MITRE ATT&CK framework.

In my case, the Navigator found the four adversaries **APT19**, **APT41**,
**menuPass** and **Moses Staff**. APT19 is a Chinese-based thread group, APT41
is a Chinese state-sponsored espionage group, and menuPass is a thread group
where individual members act in conjunction with the Chinese Ministry of State
Security (MSS). The final group, Moses Staff, is an Iranian thread group that
primarily targets Israeli companies. All these groups have in common that they
occasionally target the financial industry. You can find all this information in
the MITRE ATT&CK framework by clicking on "view" next to the search result.

{{< _figureCupper
img="mitre-att-and-ck-navigator-search.webp" 
alt="The screenshot shows the unchanged first layer with an open 'Selection Controls' sidebar. The search field contains the word 'finance' and the 'Thread Groups' results section show the four results 'APT19', 'APT41', 'menuPass' and 'Moses Staff'"
caption="Screenshot of the **Thread Groups** search result showing the four adversary groups **APT19**, **APT41**, **menuPass** and **Moses Staff**."
command="Original"
lazy="true">}}

We now have four interesting research targets for potential attack vectors
against our company. In the next step, we will prepare our first layer to
analyse the tactics and techniques of the first group, APT19.

Click the **select** button to select all techniques from APT19. Now switch from
the **Selection Controls** to the **Layer Controls** and change the name in the
**layer settings** from "Layer 1" to "APT19". Next, open the **color setup**
menu to change the colour palette to the preset **transparent to red**. As we
are analysing four groups, set the **High value** to "4". To apply the colour
palette, go to the last menu **Technique Controls** and set the **scoring**
option to 1.

Your layer should now look like this:

{{< _figureCupper
img="mitre-att-and-ck-navigator-apt19.webp" 
alt="The screenshot shows the blank view on the MITRE ATT&CK matrix again, but this time the techniques of the APT19 thread group have a red background color. Highlighted are the techniques 'Drive-by Compromise' (tactic: Initial Access), 'Command and Scripting Interpreter' (tactic: Execution) and 'Deobfuscate/ Decode Files or Information' (tactic: Defense Evasion)'"
caption="Screenshot of the APT19 layer set up, showing their usual techniques with a red background."
command="Original"
lazy="true">}}

In the screenshot, we can now see the techniques that the APT19 thread group has
used in the past to attack targets in the financial industry. This is already
useful information. But we can do better. Now repeat the steps of the APT19
group for the other three adversaries, APT41, menuPass and Moses Staff, each on
their own layer.

When you are finished, create a new layer by clicking **Create Layer from Other
Layers**. Next, select the latest version of ENTERPRISE ATT&CK as the domain. To
merge the scores of the other layers, set the **score expression** to `a+b+c+d`.
To finish, select the **gradient** and **coloring** from any other layer, e.g.
APT19. Here is a screenshot of the settings I have configured:

{{< _figureCupper
img="mitre-att-and-ck-navigator-merging-layers.webp" 
alt="The screenshot shows the filled out input fields, described in the previous paragraph, including the domain 'ENTERPRISE ATT&CK v16', the score expression 'a+b+c+d', the gradient and coloring from the layer 'APT19'."
caption="Screenshot of the **Create Layer from Other Layers** form set up to create the adversaries layer."
command="Original"
lazy="true">}}

Now create the new layer and rename it "Adversaries" in the **Layer Controls**.
Using the gradient we set up earlier and the score range of 0-4, we can now see
the common techniques of our thread groups. This is where you start, this is
your foot in the door. You don't need to focus on every single technique in the
framework, just start by looking at the most important ones. After that, focus
on those that are less overlapping or do not overlap.

In the following screenshot (or in your own navigator) you can see that we have
the overlapping technique **System Network Configuration Discovery** of the
tactic **Discovery** with a maximum score of four and then the next four with a
score of three:

- Exploit Public-Facing Application (tactic: Initial Access)
- Deobfuscate/ Decode Files or Information (tactic: Defense Evasion)
- System Information Discovery (tactic: Discovery)
- Ingress Tool Transfer (tactic: Command and Control)

Then we have 13 overlapping techniques with a score of two:

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

Finally, a few more with a score of one, so that there is no overlap between the
groups of threads:

{{< _figureCupper
img="mitre-att-and-ck-navigator-adversaries.webp" 
alt="The screenshot shows the combined layer of adversaries, with a stronger color on the overlapping techniques 'Exploit Public-Facing Application' and 'Valid Accounts' (tactic: Initial Access) with the scores 3 and 2, 'Windows Management Instrumentation' (tactic: Execution) with a score of 2, 'Valid Accounts' (tactic: Privilege Escalation) with a score of 2, 'Deobfuscate/ Decode Files or Information' (tactic: Defense Evasion) with a score of 3, 'File and Directory Discovery' and 'Network Service Discovery' (tactic: Discovery) both with a score of 2, 'Automated Collection' and 'Data from Local System' (tactic: Collection) both also with a score of 2 and 'Ingress Tool Transfer' (tactic: Command and Control) with a score of 3."
caption="Screenshot of the matrix including the combined scores and highlighted techniques."
command="Original"
lazy="true">}}

### Mitigating attack vectors

Now that we know the most commonly used techniques to attack our example
industry, we can start using the MITRE ATT&CK framework to look for mitigations
that we can apply to reduce the impact and/or success of the adversaries.

Unfortunately, starting with
[System Network Configuration Discovery](https://attack.mitre.org/techniques/T1016/),
there are no known mitigations because they are exploitable due to system
failure, as you can read on the techniques page in the framework. So we move on
to
[Exploit Public-Facing Application](https://attack.mitre.org/techniques/T1190/)
with a score of three.

This time we have a couple of mitigations, such as
[Application Isolation and Sandboxing](https://attack.mitre.org/mitigations/M1048/).
These mitigations are methods that we can look up immediately. We can go to our
(software) infrastructure and check if the mitigations are already applied or if
we have a todo.

{{< _figureCupper
img="mitre-att-and-ck-navigator-mitigation.webp" 
imgLink="https://attack.mitre.org/techniques/T1190/"
alt="The screenshot shows a table of the mitigations for the technique 'Exploit Public-Facing Applications'. The table contains the following mitigations: M1048 'Application Isolation and Sandboxing', M1050 'Exploit Protection', M1030 'Network Segmentation', M1026 'Privileged Account Management', M1051 'Update software' and M1016 'Vulnerability Scanning'. All these techniques are links, pointing to their mitigation site."
caption="Screenshot of the **Exploit Public-Facing Application** technique's mitigations."
command="Original"
lazy="true">}}

Let's say we've already done this for all the overlapping techniques in the
previous section with a score of four and three. Our team has quickly reviewed
and implemented the MITRE ATT&CK mitigations.

Now we can add a new layer to the navigator for the techniques we have already
mitigated. This time we add a fresh layer again with the latest version of the
framework and we name the layer "defence" and change the colour palette to the
preset **transparent to blue** with a **High value** of "4".

Next we `CTRL` select all the mitigated adversary techniques with a score of
three and set the score in our defence layer to 4 as well. And because the
**System Network Configuration Discovery** technique isn't mitigated, we just
set its score to 1.

{{< _figureCupper
img="mitre-att-and-ck-navigator-defense.webp" 
alt="The screenshot shows the defense layer with the two visible, blue highlighted techniques 'Exploit Public-Facing Application' and 'Deobfuscate/ Decode Files or Information'. The other techniques have there default, grey background."
caption="Screenshot of the defense layer with two visible, blue highlighted techniques."
command="Original"
lazy="true">}}

OK, this is our starting point for defence. The next step is to compare the
thread group techniques with our mitigated ones. To do this we add a new layer,
this time we click **Create Layer from Other Layers** again. As before, we
choose the latest version of ENTERPRISE ATT&CK as the domain, and finally we
subtract the defence (f) from the adversaries (e), so set the score expression
to `e-f`. And this time we don't set a gradient or colouring, we choose another
one for the comparison.

{{< _figureCupper
img="mitre-att-and-ck-navigator-setup-current-state.webp" 
alt="The screenshot shows the filled out input fields, described in the previous paragraph, including the domain 'ENTERPRISE ATT&CK v16', the score expression 'e-f'."
caption="Screenshot of the **Create Layer from Other Layers** form set up to create the current state layer."
command="Original"
lazy="true">}}

After creating the layer, we change its name in the **Layer Controls** to
"current state". Then we change the gradient score range to "0" for low and "2"
for high. To improve the colours, we select the **green to red** preset, so the
lower the score, the better we are protected against the technique.

As a result, you can see that the techniques with a previous score of three now
have a score of "-1", which makes them super green. This way we can see what we
have achieved through our mitigation and where we still need to work.

{{< _figureCupper
img="mitre-att-and-ck-navigator-current-state.webp" 
alt="The screenshot shows the combined matrix of adversary scores and our defense scores. The mitigated techniques are displayed with a green background color, the low scored techniques are yellow and the overlapping, high scored techniques are still read."
caption="Screenshot of the combined matrix of adversaries and our defense positions."
command="Original"
lazy="true">}}

To avoid throwing all your work in the trash every time, you can also export all
your layers into a single JSON and import it later in the same way. You can find
the export option in the **Layer Controls** under **export**, right next to the
settings.

## The MITRE ATT&CK framework's major drawback.

Right now my biggest problem with the MITRE ATT&CK framework is its limited
ability to filter and find thread groups based on a given industry. My example
only works for the big ones like finance, healthcare, military, etc. I wanted to
use the 'e-commerce' industry I currently work in as an example for this post,
but there isn't a single thread group related to it in the framework. So I had
to pick a big industry like finance.

Actually, that's my only problem at the moment. If you know of a good adversary/
thread group to industry mapping that is also compatible with the MITRE ATT&CK
adversaries, please contact me at Mastodon `@lukasrotermund@social.tchncs.de`.
You will find an update here if I find a good source for a better mapping.

## Some final thoughts

I really like the MITRE ATT&CK framework and the Navigator. The MITRE community
has built something very impressive here. It's rich in information and the
Navigator is a very easy to use tool. The framework provides a clear and
minimalist structure but is also able to provide a lot of structured
information.

I would like to be able to use it in a better way and analyse attack vectors for
every industry, not just the big ones.
