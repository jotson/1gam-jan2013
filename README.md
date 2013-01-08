# Running the game

- Download the source files
- Unzip into a folder named "january" keeping directory structure intact
- Run it with LÖVE. Example:
        $ love january

# Dev journal

## January 2, 2013

Started coding my first game for #onegameamonth. Spent about a week prior looking over frameworks and decided on using LÖVE with the Zoetrope library. Why? I didn't know Lua but I was curious about it because I know it's fairly widely used in game development. The documentation is good. It has a good reputation for speed (coding-wise and FPS-wise). And it makes distributing finished games easy-ish. I considered pygame but I get a very strong obsolete vibe from it.

Lua is very easy to pick up. Took just a bit of effort to wrap my head around tables and when to use colons instead of dots.

Ran "Hello, World".

Created a player sprite and hooked up keyboard controls using stock LÖVE. I left out Zoetrope at first just to see what I would gain by adding it. Zoetrope immediately let me eliminate a bunch of basic physics code (velocity, acceleration, etc) and helpfully defines all units in terms of pixels/second.

I now have a ship that can use thrusters to move around the screen.

Added boundary checking to make the ship bounce off the window edges.

Added an animation to show the thrust exhaust. Used the Zoetrope Factory class to automatically recycle the particles as needed.

Experimented a bit with PixelEffects (GLSL shaders). What is this I don't even.

I'm finding that I have to keep reminding myself not to polish. I spent a long time getting the thrust feel to a point where it felt good because I think that's important for gameplay. But I also spent more time than I should have on the appearance of the ship and thrust particles which doen't matter at all at this stage.

On the other hand, I'm finding that it's fun to do a little polishing here and there and to jump between subjects (mechanics to graphics to sound) to keep things interesting. When I get bored doing one thing, there's always something else I can jump to.

Hours: 5

## January 3, 2013

Read an article about game mechanics at Wikipedia: http://en.wikipedia.org/wiki/Game_mechanics

## January 4, 2013

Added a thrust sound effect. I started with a short looping sample. I wanted it to fade in but that looked like it was going to take a hack so it turned out it was much simpler to just make the loop much longer (1 minute) and include the fade in at the beginning of the sample. Used Audacity to create the sound (brown noise generator + tone generator + filters).

Added fuel consumption and a fuel gauge to the ship. I started on a HUD, and that was easy, but I've decided to try to make as many elements as possible visual instead of textual. The fuel gauge is drawn as a colored arc within the ship radius.

Added fuel that can be collected by colliding with it.

Did some experimenting with camera following the player and found that I'd written my sprite drawing methods in a way that prevented it from working. Rewrote those correctly and now everything works as expected (camera following the player is kind of neat) except that my thrust particles don't seem to be receiving their coordinates correctly from the framework for some reason. It's like they're not part of the update loop. Can't see the solution right now. It'll probably come to me in the morning.

Got it! With Zoetrope, sprite's might not be drawn correctly unless they have a width and height > 0.

Hours: 3

## January 7, 2013

Added a simple animation to show fuel being absorbed into the player ship. It works by checking for a "collision" between the fuel pods and the ship. All of the collision detection and animation code is in the fuel pods rather than the ship. If it was in the ship, I'd have to code a loop to check for collisions with each fuel pod.

Changed mechanics a little so that the ship's fuel can only increase to a maximum amount. Any fuel collected beyond that is added to a surplus fuel counter which I'm thinking is, essentially, the player score.

Hours: 1

## January 8, 2013

Tweaking mechanics again. Lesson learned: designing a game and tweaking behavior is very time consuming. I may just set out to just flat out clone something next month.

