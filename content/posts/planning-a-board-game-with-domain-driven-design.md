---
title: "Planning a board game with domain-driven design"
date: 2021-03-27T14:50:26+01:00
draft: true
images: ["/assets/pexels-cottonbro-4874323.jpg"]
tags: ["domain-driven-design", "project-multiplayer-platform", "microservice"]
description: "In this post, we'll see how Go tests are built more robustly with the quick package 
and how we can avoid incorrectly chosen parameters."
---

For two years now, I’ve been planning to setup a playground-microservice architecture. In the 
upcoming series I will realize a project I have been dreaming for a while now – a multiplayer gaming 
platform with some small games, all build on top of a solid, scalable microservice architecture.

{{< toc >}}

## Some thoughts about this new series

My plan is to share my learning- and development-journey with you. By sharing my thoughts through 
the posts I'm documenting everything for myself and you may learn something about using 
domain-driven design, microservices, kubernetes, golang, event sourcing, etc. in real world 
projects. Everyone can implement my code and my projects because its open source and licensed under 
MIT. 

This post is an introduction and I will start by sharing all my thoughts on this topic and we will
talk about the approach of domain-driven design to plan the first board game of the platform without
consideration of the code. We will take a look at the planned infrastructure of the services so that
you can better understand their communication.

No aspect of the topics we talk about in this post is fixed and everything could and will change in
the course of this series. It's often important to just start your projects and it's totally okay to 
start without a 100% masterplan.

## The board game project idea

Two years ago, on a hot summer evening, I was sitting with some friends in a pub garden talking 
about nerdy IT stuff, having some nice cold beers and watching the boats swimming by on the river.

A friend told me about a cool programming boardgame he played all night long. Every player controlls 
his own cute little killer robot and has the goal to destroy all other robots. The game is a 
deck-building game where every player has his own code deck. The decks contain four different types
of cards: 
- statements, like _if-else_ and _switch-case_
- loops, like _for_-, _while_, or _do-while_
- commands, like "shoot laser", "move forward", "turn left", or "turn right"
- queries, like "is the next field blocked?" or "is the right field blocked?" 

Every card provides an image and the code that makes it easier for programming beginners and 
non-programmers to understand the action of the card. 

At the beginning of every round, every players draws a card. After the drawing phase all players 
choose whether they write a small code by combining conditions, loops, commands and queries or 
skip the coding. In the last phase every player with a code or a combination of cards rolls a dice 
and the player with the highest die result starts by running his code. The code is processed 
synchronously, card by card in the predefined order. If a robot is killed during the code execution, 
its code won't be executed. After the code has been executed the next players code 
execution starts.

Sadly I don't no the exact rules of the board game because it's an indian indie game and I can't
buy it here in Germany. But thats no problem because I don't want to copy the game one by one. Since
I only know the rough concept of the game from my friends story the most parts are interpreted and 
are a result of my imagination.

Another change I have in my mind is to add multiple decks with different programming languages so 
that every programmer can choose his favorite style of playing this game. Furthermore every robot 
has three shields to protect himself against a laser shoot. Maybe there will be a repair command to 
add new shields up to the maximum of three. Last but not least I attend to change to way the code 
execution order is determined. The way its done by the board game is fine but I don't want to add 
clockwise mechanism to the online game. I thought about adding a 
{{< abbr "CI/CD" "continues integration / continues delivery" >}} pipeline to the game. The pipeline
is a basic first in – first out pipeline. The player who adds his code first is the player who 
starts running his code after all players has pushed their code.

For me it's fascinating how easy it is to explain the mechanism's of loops and if-/ 
switch-statements and its benefits with this game. It's easy to see a benefit in walking and 
shooting laser beams within a loop then just doing it once. One shooting command can be used to 
shoot a lot of laser beams instead of just one – a total waste of CPU. 

I can't wait to play the game all night long with some friends and a cold beer on a Corona-safe 
remote session.

## The bigger picture

I want to start coding right now but it's not easy with the bigger picture of a multiplayer gaming
platform in my head. So I decided to not start with the most complex part but instead with the board
game. In the following post we will use domain-driven design to define the domain, the bounded 
context, our aggregate and its states, and last but not least the commands and its events. 

It's my final goal to provide a multiplayer platform with a lot of funny games and a domain user 
with access to all of them. There will be a currency/ coin system and a shop to buy for example new 
programming languages as deck-skins for our first board game – I don't want to provide a pay-to-win 
mechanism, just styling. Later you can start a board game session from the platform together with
your friends. All games are connected to the platform and can share the game results to earn some 
coins for winning a game.

## Start planing the game with DDD

I could start building my APIs now, I could start by typing some endpoints to provide the 
functionality and the rules of the board game. But how sustainable will the code be? How easy is it
to change the rules? When I come back on the repository after one or two years to add a new phase to
the existing ones will it be easy to understand whats going on within the API – will I remember 
all the names, words and state? Possibly yes, possibly no. 

To build all services and especially this board game on to well documented basis, we will use 
domain-driven design. I will not describe what {{< abbr "DDD" "domain-driven design" >}} is and I
will not using the 100%-blue-book-{{< abbr "DDD" "domain-driven design" >}} by Evans because it's 
just not my goal to build a 100% perfect project. Many other developers tried to explain what 
{{< abbr "DDD" "domain-driven design" >}} is and they all described it better then I ever could. If
you want to learn more about {{< abbr "DDD" "domain-driven design" >}} and all its patterns and 
components you will find sources in german and english at the end of this post.

### Understanding the domain

Lets start by looking at our previous defined rule set and the rough description of the game. The 
domain is the game itself. The game play's in a post-apocalyptic context and an initial name for the 
project could be **Last Robo Wars**. Maybe not a perfect name but for now its ok. It shouldn't be a 
problem to find a better name later this series. Next we will first try to find names for all the 
commands. This helps me to shape the project and its rules into a flow.

#### Defining the commands

First, there has to be a command to start a game. The common way of defining a command is to use a
verb in the imperative followed by a substantive. By applying this simple rule our first command 
could be _startGame_. But is _start_ a good verb, do we really start a game, or do shouldn't we 
prepare a game – therefore the command could be _prepareGame_. After thinking a while about what we
attend to do with the game, I decided to choose _initializeGame_. Initialize is a common verb, used
to indicate a setup process. To initialize a game, the host player needs to provide his ID and a 
second ID for the game.

After the game has been initialized by the host player there needs to be kind of a lobby or a room 
where other players can join. A command to join a game could be simple _joinGame_. When a player 
joins a game he has to provide his ID, a name and the ID of the game he whats to join. The 
opposite command is _leaveGame_, which takes the game's and the player's IDs as arguments. Joining a 
game is only possible if the game hasn't started – but a player can always leave a game.

The host player can start a game, all other players are not allowed to. Now the previous command 
_startGame_ fits and could be used to start a game. The command only needs the ID of the game as an
argument.

Now its getting a little bit more tricky because we have to find commands for the phases. Lets start
with the drawing phase. Each player should start the game with five cards and within every drawing 
phase he draws one card. The command to draw a card is _drawCard_ and it requires the players ID. 
The command can be applied within the drawing phase. If a player has no more cards left when drawing
a card he loses the game. When all players have drawn their cards, the drawing phase ends and the 
coding phase starts.

The players now have to choose whether they combine some cards to a script, or skip the phase. I 
like the name _coding phase_, because thats what happens here. The command to skip the coding could 
be _skipCoding_. Next we need a command if the player chooses to play at least one card in the 
coding phase. There is no limit of how many card can be combined. Now we have a lot of possible 
terms for the command. The first that comes to my mind is _playCards_, but that doesn't really fit into 
all the other domain terms and the existing set of commands. The goal is to provide a pipeline/ 
build pipeline that holds all pushed scripts. Thinking in this terminology a good command could be 
_pushScript_. It doesn't matter how many cards are part of the script, what matters is the order. Both commands, _skipCoding_ and _pushScript_ require the players ID as an parameter. 
_pushScript_ additionally requires the ordered list of card IDs.

When all players pushed there code or skipped the coding, the third phase starts. In that last phase
the build pipeline is processed. 