package
{
	import cam.Camera;
	import collision.CollisionDetection;
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.events.Event;
	import graphic.PauseOverlay;
	import graphic.StartGameOverlay;
	import input.InputKey;
	import input.InputManager;
	import obj.Boulder;
	import obj.BunnyBoard;
	import obj.BunnyCopter;
	import obj.BunnyShip;
	import obj.Laser;
	import obj.Obstacle;
	import obj.Player;
	import obj.VehicleType;
	import obj.Wall;
	import random.Rndm;
	/**
	 * ...
	 * @author Ethan Roseman
	 */
	public class HelicopterGame extends GameScreen {		
		public var gameSpeed:Number = 1;
		public var gameRunning:Boolean;
		public var gameStarted:Boolean = false;
		public var allowControl:Boolean = false;
		
		public var camera:cam.Camera;
		public var debug:Boolean;
		
		public var pauseMenu:PauseOverlay;
		public var startMenu:StartGameOverlay;
		public var rand:Rndm;
		public var player:Player;
		
		public var vehicleType:int;
		public var scrollSpeed:Number;
		public var direction:String;
		public var levelEnd:int;
		
		public var mouseUpCount:int = 0;
		public var mouseDownCount:int = 0;
		public var pauseDownCount:int = 0;
		public var buttonPresses:int = 0;
		public var allowedButtonPresses:int;
		
		public var distance:Number = 0;

		public var pauseDownLast:Boolean;
		
		public var wallVector:Vector.<Wall>;
		public var wallContainer:MovieClip;
		public var currentWallNum:int;
		
		public var boulderTimer:Number;
		public var obstacleVector:Vector.<Boulder>
		public var boulderContainer:MovieClip;
		
		public var offsetContainer:MovieClip;
		public var gameGraphics:MovieClip;
		public var uiGraphics:MovieClip;
		
		public var laserVector:Vector.<Laser>;
		
		public var levelData:Object;
		
		public var background:MovieClip;
		public var backgroundTexture:Bitmap;
		public var foregroundTexture:Bitmap;
		public var boulderTexture:Bitmap;
		
		public var lineClip:Sprite; //temp
		public var ap:AutoMC; //temp
		
		public function HelicopterGame(levelDat:Object, vehicle:int, debugMode:Boolean) {
			//temp
			lineClip = new Sprite();
			addChild(lineClip);
			//temp
			
			offsetContainer = new MovieClip();
			gameGraphics = new MovieClip();
			uiGraphics = new MovieClip();
			addChild(offsetContainer);
			offsetContainer.addChild(gameGraphics);
			addChild(uiGraphics);
			
			gameGraphics.x = -Common.GAMEWIDTH / 2;
			gameGraphics.y = -Common.GAMEHEIGHT / 2;
			
			camera = new Camera(offsetContainer);
			camera.update();
			
			debug = debugMode;
			
			levelData = levelDat;
			vehicleType = vehicle;
			boulderTimer = levelData.boulderRate;
			
			createPauseMenu();
			initializeLevel();
			drawLevel();
			createWalls();
			createPlayer(vehicleType);
			createStartMenu();
			
			//temp
			ap = new AutoMC();
			ap.x = 190;
			ap.y = 10;
			ap.visible = false;
			uiGraphics.addChild(ap);
			//temp
		}
		
		public function start():void {
			uiGraphics.removeChild(startMenu);
			
			gameStarted = true;
			gameRunning = true;
			
			//Camera test events
			//camera.rotate(60, 30, 30, 30, CameraEventStyle.normal);
			//camera.panX(60, -150, CameraEventStyle.normal);
			//camera.zoom(60, 1.4, CameraEventStyle.normal);
			
			//camera.panX(90, -300, CameraEventStyle.accelerate);
			//camera.panY(90, 30, CameraEventStyle.normal);
			//camera.pan(90, 0, 0, "normal");
			//camera.quake(90, 2, CameraEventStyle.accelerate);
			//camera.zoom(60, 2, CameraEventStyle.normal);
			
			//camera.quake(60, 5, CameraEventStyle.normal);
		}
		
		private function createPauseMenu():void {
			pauseMenu = new PauseOverlay(vehicleType);
			pauseMenu.visible = false;
			uiGraphics.addChild(pauseMenu);
		}
		
		private function createStartMenu():void {
			startMenu = new StartGameOverlay(vehicleType);
			uiGraphics.addChild(startMenu);
		}
		
		public function initializeLevel():void {
			gameRunning = false;
			gameStarted = false;
			wallVector = new Vector.<Wall>;
			obstacleVector = new Vector.<Boulder>;
			laserVector = new Vector.<Laser>;
			
			if (levelData.seed != -1) {
				rand = new Rndm(levelData.seed);
			}
			else {
				rand = new Rndm(Math.random() * 0xFFFFFF);
				if (debug) {
					trace("Seed: " + rand.seed);
				}
				//rand = new Rndm(8); //debug purposes
			}
			
			currentWallNum = 0;
			vehicleType = vehicleType;
			scrollSpeed = levelData.scrollSpeed;
		}
		
		public function drawLevel():void {
			wallContainer = new MovieClip();
			wallContainer.name = "wallContainer";
			boulderContainer = new MovieClip();
			boulderContainer.name = "boulderContainer";
			
			switch (levelData.backgroundID) {
				case 0:
					backgroundTexture = new Bitmap(new SectorOneBG());
					break;
				case 1:
					backgroundTexture = new Bitmap(new SectorTwoBG());
					break;
				case 2:
					backgroundTexture = new Bitmap(new SectorThreeBG());
					break;
			}
			
			switch (levelData.foregroundID) {
				case 0:
					foregroundTexture = new Bitmap(new SectorOneFG());
					break;
				case 1:
					foregroundTexture = new Bitmap(new SectorTwoFG());
					break;
				case 2:
					foregroundTexture = new Bitmap(new SectorThreeFG());
					break;
			}
			
			boulderTexture = new Bitmap(new SectorThreeFG()); //get actual texture at some point
			
			//TEMP
			backgroundTexture.width = Common.GAMEWIDTH * 3;
			backgroundTexture.height = Common.GAMEHEIGHT;
			foregroundTexture.width = Common.GAMEWIDTH * 3;
			foregroundTexture.height = Common.GAMEHEIGHT;
			boulderTexture.width = Common.GAMEWIDTH * 3;
			boulderTexture.height = Common.GAMEHEIGHT;
			//TEMP
			
			boulderTexture.mask = boulderContainer;
			foregroundTexture.mask = wallContainer;
			
			gameGraphics.addChild(backgroundTexture);
			gameGraphics.addChild(foregroundTexture);
			gameGraphics.addChild(boulderTexture);
			gameGraphics.addChild(wallContainer);
			gameGraphics.addChild(boulderContainer);
		}
		
		public function createPlayer(vehicleType:int):void {
			switch (vehicleType) {
				case VehicleType.BUNNYCOPTER:
					player = new BunnyCopter(levelData);
					break;
				case VehicleType.BUNNYBOARD:
					player = new BunnyBoard(levelData);
					break;
				case VehicleType.BUNNYSHIP:
					player = new BunnyShip(levelData);
					break;
			}
			player.gfx.x = 100;
			player.gfx.y = Common.getY(wallVector[0], player.gfx.x) + (wallVector[0].gapHeight * 0.5);
			if (levelData.playerRotation == 1 && vehicleType == VehicleType.BUNNYCOPTER && player.autoRotate){
				player.gfx.rotation = player.getCaveRotation(wallVector);
			}
			gameGraphics.addChild(player);
		}
		
		
		public override function onTick(keysPressed:InputManager):void {
			handleInput(keysPressed);
			handlePause(keysPressed);
			if (gameStarted && gameRunning) {	
				camera.onTick();
				moveObjects();
				createWalls();
				moveTextures();
				handlePlayer(keysPressed);
				makeBoulders();
				checkCollisions();
				garbageCollection();
			}
		}
		
		private function handleInput(keysPressed:InputManager):void {
			if (vehicleType == VehicleType.BUNNYBOARD && !gameStarted && ((keysPressed.isKeyPressed(InputKey.UP)) || keysPressed.isKeyPressed(InputKey.DOWN))) {
				start();
			}
			
			//temp below
			if (keysPressed.isKeyPressed(InputKey.E)) {
				gameSpeed /= 1.1;
			}
			else {
				gameSpeed *= 1.5;
			}
			if (gameSpeed > 1) gameSpeed = 1;
			if (gameSpeed < 0.35) gameSpeed = 0.35;
			
			if (keysPressed.isKeyPressed(InputKey.RIGHT)) {
				scrollSpeed++;
			}
				
			if (keysPressed.isKeyPressed(InputKey.LEFT)) {
				scrollSpeed--;
				if (scrollSpeed < 0) scrollSpeed = 0;
			}
			
			if (keysPressed.isKeyPressed(InputKey.R)) {
				if (scrollSpeed != 0){
					player.xSpeed = scrollSpeed;
					scrollSpeed = 0;
				}
			}
			
			if (keysPressed.isKeyPressed(InputKey.F)) {
				playerDied();
			}
			
			//Work on autoplaying after the rest of the game is done
			/*
			if (keysPressed.isKeyPressed(InputKey.Q)) {
				player.autoPlaying = true;
				ap.visible = true;
				setChildIndex(uiGraphics, numChildren -1);
			}
			
			else {
				player.autoPlaying = false;
				ap.visible = false;
			}*/
		}
		
		private function handlePause(keysPressed:InputManager):void {
			if (gameStarted && !pauseDownLast) {
				if (gameRunning && keysPressed.isKeyPressed(InputKey.P)) {
					pause(); //used to pass mouseDown and set it equal to false, not sure why
				}
				else if (!gameRunning && unpausePressed(keysPressed)) {
					unpause();
				}
			}
			pauseDownLast = keysPressed.isKeyPressed(InputKey.P);
		}
		
		public function pause():void {
			pauseMenu.visible = true;
			setChildIndex(uiGraphics, numChildren - 1);
			gameRunning = false;
			pauseDownCount = mouseDownCount;
		}
		
		public function tryPause():void {
			if (gameRunning) {
				pause();
			}
		}
		
		public function unpause():void {
			pauseMenu.visible = false;
			gameRunning = true;
		}
		
		public override function handleMouse(e:Event):void {
			switch (e.type) {
				case "mouseUp":
					mouseUpCount++;
					//buttonPresses++;
					break;
				case "mouseDown":
					if (gameRunning && vehicleType == VehicleType.BUNNYSHIP) {
						var newLaser:Laser = BunnyShip(player).shoot();
						
						if (newLaser != null) {
							laserVector.push(newLaser);
							gameGraphics.addChild(newLaser);
						}
					}
					if ((vehicleType == VehicleType.BUNNYCOPTER || vehicleType == VehicleType.BUNNYSHIP) && !gameStarted) {
						start();
					}
					mouseDownCount++;
					buttonPresses++;
					break;
				case "mouseLeave":
					if (gameRunning && (vehicleType == VehicleType.BUNNYCOPTER || vehicleType == VehicleType.BUNNYSHIP)) {
						pause();
					}
					break;
			}
		}
		
		private function unpausePressed(keysPressed:InputManager):Boolean {
			if ((vehicleType == VehicleType.BUNNYCOPTER || vehicleType == VehicleType.BUNNYSHIP) && keysPressed.isMouseDown() && pauseDownCount != mouseDownCount) {
				return true;
			}
			if (vehicleType == VehicleType.BUNNYBOARD && (keysPressed.isKeyPressed(InputKey.UP) ||keysPressed.isKeyPressed(InputKey.DOWN))) {
				trace("problem");
				return true;
			}
			if (keysPressed.isKeyPressed(InputKey.P)) {
				return true;
			}
			return false;
		}
		
		public function makeBoulders():void { 
			if (levelData.boulderRate != 0) {
				boulderTimer += gameSpeed * (scrollSpeed / levelData.scrollSpeed);
				if (boulderTimer >= levelData.boulderRate) {
					boulderTimer = 0;
					var bould:Boulder = new Boulder(rand);
					var boulderWall:Wall = Common.getWallAtX(wallVector, Common.GAMEWIDTH + (bould.width * 0.5));
					
					bould.x = Common.GAMEWIDTH + (bould.width * 0.5);
					bould.y = getBoulderY(boulderWall, bould);
					
					boulderContainer.addChild(bould);
					
					obstacleVector.push(bould);
				}
			}
		}
		
		public function getBoulderY(wall:Wall, bould:Boulder):Number {
			var min:Number = Common.getY(wall, bould.x) + (bould.height * 0.5);
			var max:Number = min + wall.gapHeight - bould.height;
			var dist:Number = max - min;
			
			if (player.gfx.height > dist - (bould.height * 0.5)) {
				throw new Error("Error: Level cave too skinny for boulders to fit");
			}
			
			if (dist * 0.5 < player.gfx.height) {
				var upperBoundary:Number = max - player.gfx.height;
				var lowerBoundary:Number = min + player.gfx.height;
				var spawnChoice:Boolean = rand.boolean();
				
				if (spawnChoice) {
					return rand.float(min + 10, upperBoundary - 10);
				}
				else {
					return rand.float(lowerBoundary + 10, max - 10);
				}
			}
			return rand.float(min + 10, max - 10);
		}
		
		public function moveObjects():void {
			for (var i:int = 0; i < wallVector.length; i++) {
				wallVector[i].x -= scrollSpeed * gameSpeed;
			}
			
			for (i = 0; i < obstacleVector.length; i++) {
				obstacleVector[i].x -= scrollSpeed * gameSpeed;
				obstacleVector[i].rotation += obstacleVector[i].rotateAmount * gameSpeed;
			}
			
			moveLasers();
			
			distance += gameSpeed * (scrollSpeed / levelData.scrollSpeed);
			scrollSpeed += levelData.scrollSpeedChangeRate;
		}
		
		public function moveTextures():void {
			backgroundTexture.x -= scrollSpeed * 0.8 * gameSpeed;
			foregroundTexture.x -= scrollSpeed * gameSpeed;
			boulderTexture.x -= scrollSpeed * gameSpeed;
			if (backgroundTexture.x <= -Common.GAMEWIDTH * 2) {
				backgroundTexture.x = 0;
			}
			if (foregroundTexture.x <= -Common.GAMEWIDTH * 2) {
				foregroundTexture.x = 0;
			}
			if (boulderTexture.x <= -Common.GAMEWIDTH * 2) {
				boulderTexture.x = 0;
			}
		}
		
		public function handlePlayer(keysPressed:InputManager):void {
			if (player.autoPlaying){
				player.autoPlay(wallVector, currentWallNum, keysPressed, obstacleVector);
			}
			player.move(wallVector, keysPressed, gameSpeed);
			
			if (debug){
				drawDebugLines();
			}
		}
		
		public function drawDebugLines():void {
			//ai lines
			//lineClip.graphics.clear();
			/*lineClip.graphics.lineStyle(1);
			if (player.range != null){
				lineClip.graphics.moveTo(0, player.range[0].x); 
				lineClip.graphics.lineTo(640, player.range[0].x);
				lineClip.graphics.moveTo(0, player.range[0].y); 
				lineClip.graphics.lineTo(640, player.range[0].y);
				if (player.range.length > 1){
					lineClip.graphics.moveTo(0, player.range[1].x); 
					lineClip.graphics.lineTo(640, player.range[1].x);
					lineClip.graphics.moveTo(0, player.range[1].y); 
					lineClip.graphics.lineTo(640, player.range[1].y);
				}
			}
			gameGraphics.addChild(lineClip);*/
			
			//player loc lines
			//lineClip.graphics.clear();
			/*lineClip.graphics.lineStyle(1);
			lineClip.graphics.moveTo(player.gfx.x, 0); 
			lineClip.graphics.lineTo(player.gfx.x, 480);
			lineClip.graphics.moveTo(0, player.gfx.y);
			lineClip.graphics.lineTo(640, player.gfx.y);
			gameGraphics.addChild(lineClip);*/
			
			//minMax AI lines
			/*lineClip.graphics.clear();
			lineClip.graphics.lineStyle(2);
			lineClip.graphics.moveTo(0, player.minY); 
			lineClip.graphics.lineTo(640, player.minY);
			lineClip.graphics.moveTo(0, player.maxY); 
			lineClip.graphics.lineTo(640, player.maxY);
			gameGraphics.addChild(lineClip);*/
			
			//target line
			//lineClip.graphics.clear();
			/*lineClip.graphics.lineStyle(1, 0xFF0000);
			lineClip.graphics.moveTo(0, player.targetY);
			lineClip.graphics.lineTo(640, player.targetY);
			gameGraphics.addChild(lineClip);*/
		}
		
		public function checkCollisions():void {
			if (vehicleType == VehicleType.BUNNYSHIP) {
				checkLaserCollisions();
			}
			checkPlayerCollisions();
		}
		
		public function checkPlayerCollisions():void {
			var list:Vector.<DisplayObject> = new Vector.<DisplayObject>;
			
			//OPTIMIZE to get walls that are around the player..no need to check others
			for each (var wall:Wall in wallVector) {
				list.push(wall);
			}
			
			//OPTIMIZE to get obstacles that are around the player, same as above
			for each (var obstacle:Obstacle in obstacleVector) {
				list.push(obstacle);
			}
			
			for each (var dispObj:DisplayObject in list) {
				var coll:Boolean = CollisionDetection.testObjects(player, dispObj, gameGraphics);
				if (coll) {
					playerDied();
					break;
				}
			}
		}
		
		public function checkLaserCollisions():void {
			//To fill
		}
		
		private function moveLasers():void {
			for each (var laser:Laser in laserVector) {
				moveLaser(laser);
			}
		}
		
		private function moveLaser(laser:Laser):void {
			laser.gfx.x += laser.vector.x * gameSpeed;
			laser.gfx.y += laser.vector.y * gameSpeed;
		}
		
		private function createWalls():void {
			while (wallVector.length == 0 || wallVector[wallVector.length - 1].x + wallVector[wallVector.length - 1].width < 640 + 200) {
				createWall();
			}
		}
		
		public function createWall():void {
			var startX:int = 0;
			var tmpPassedWall:Wall = null;
			currentWallNum++;
			
			if (wallVector.length > 0) {
				startX = wallVector[wallVector.length - 1].x + wallVector[wallVector.length - 1].width;
				tmpPassedWall = wallVector[wallVector.length - 1];
			}
			
			var tmpWall:Wall = new Wall(rand, currentWallNum, levelData, tmpPassedWall);
			
			wallVector.push(tmpWall);
			
			tmpWall.x = startX;
			wallContainer.addChild(tmpWall);
		}
		
		private function garbageCollection():void {
			if (wallVector[0].x + wallVector[0].width < 0) {
				wallContainer.removeChild(wallVector[0]);
				wallVector.splice(0, 1);
			}
			for (var i:int = 1; i < obstacleVector.length; i++) {
				if (obstacleVector[i].x + (obstacleVector[i].width * 0.5) < 0) {
					boulderContainer.removeChild(obstacleVector[i]);
					obstacleVector.splice(i, 1);
				}
			}
			for each (var laser:Laser in laserVector) {			
				if (laser.gfx.x > Common.GAMEWIDTH || laser.gfx.x < -laser.width || laser.gfx.y > Common.GAMEHEIGHT || laser.gfx.y < 0) {
					removeLaser(laser);
				}
			}
		}
		
		public function removeLaser(laser:Laser):void {
			gameGraphics.removeChild(laser);
			laserVector.splice(laserVector.indexOf(laser), 1);
		}
		
		public function playerDied():void {
			var distance:Number = Common.roundToDecimal(distance, 3);
			trace("Distance travelled: " + distance);
			GameContainer(parent).resetGame(distance);
		}
	}
}