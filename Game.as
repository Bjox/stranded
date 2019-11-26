package {

	import flash.display.*;
	import flash.text.*;
	import flash.events.*;
	import flash.utils.Timer;
	import flash.utils.getTimer;
	import flash.net.*;
	import flash.errors.IOError;
	

	public class Game extends MovieClip {
		
		private const HIGHSCORE_HOST:String = "http://stranded.yeskis.com:1366/reporths";
		
		//VARS
		private var energyDrainHit:Number = -0.5;
		private var energyDrainWalking:Number = -0.03;
		private var hungerDrainTick:Number = -0.02;


		private var left:Boolean;
		private var right:Boolean;
		private var up:Boolean;
		private var down:Boolean;
		
		//Lyder
		public var hitLyd:HitLyd = new HitLyd();
		public var swingLyd:SwingLyd = new SwingLyd();
		public var pickUpLyd:PickUpLyd = new PickUpLyd();
		private var pickUpLydSpilt:Boolean;
		
		public var scoreTimer:Timer = new Timer(1000, 1);
		public var score:Object = ({hours: 0}, {minutes: 0}, {seconds: 0});
		private var startTime:uint;
		public var difficulty:Number;
		public var drainMult:Number = 1;
		
		private var canDrink:Boolean = true;
		private var drinkTimer:Timer = new Timer(10000);
		private var mobCheck:Boolean;
		private var locEvent;
		private var sleeping:Boolean;
		private var canSleep:Boolean = true;
		private var sleepTimer:Timer = new Timer(30000);

		public var mapSize;
		public var mapData;
		public var entData;
		public var currentX:int = 0;
		public var currentY:int = 0;
		public var remainingX:int;
		public var remainingY:int;
		public var xmove:Number = 0.0;
		public var ymove:Number = 0.0;
		
		public var tileID:Array = new Array();
		public var entID:Array = new Array();
		public var tiles:Array = new Array();
		public var entities:Array = new Array();
		public var tempTiles:Array = new Array();
		public var entsInRange:Array = new Array();
		public var staticObjects:Array = new Array();
		public var itemList:Array = new Array();
		public var recipe:Array = new Array();
		public var mobs:Array = new Array();
		
		public var infoText:TextField = new TextField();
		public var energyTick:Timer = new Timer(150);
		
		//Spawn point
		public var spawnPoint = {x:20,y:225};
		
		public var viewDist:int = 21;
		public var scrollSpeed:int = 4; //MÅ GÅ OPP I 32

		public var window = new Window_mc(((spawnPoint.x+1)*32)+104,((spawnPoint.y+1)*32),400,64);
		public var miniMap:MapPic = new MapPic();
		public var spiller = new Spiller();
		public var inventory = new Inventory((viewDist-2)*32);

		public var playerName:String;
		public var highscoreEnabled:Boolean;


		public function Game(xSize:int, ySize:int, difficulty:Number, playerName:String, highscoreEnabled:Boolean):void {
			this.playerName = playerName;
			this.highscoreEnabled = highscoreEnabled;
			trace("Player name: " + playerName);
			
			this.addEventListener(Event.ENTER_FRAME, frame);
			energyTick.addEventListener(TimerEvent.TIMER, drainEnergyTick);
			scoreTimer.addEventListener(TimerEvent.TIMER_COMPLETE, scoreTick);
			drinkTimer.addEventListener(TimerEvent.TIMER, allowDrinking);
			sleepTimer.addEventListener(TimerEvent.TIMER, allowSleep);
			
			mapSize = {x:xSize,y:ySize};
			mapData = new Map(xSize,ySize);
			entData = new Ent(xSize,ySize);
			
			this.difficulty = difficulty;
			if (difficulty == 0.5) trace("Difficulty: easy");
			if (difficulty == 1) trace("Difficulty: normal");


			//overlay = new Overlay(mapSize.x,mapSize.y,spawnPoint.x,spawnPoint.y,viewDist);

			if (32 % scrollSpeed != 0) trace("Feil scroll-hastighet! Må være delelig med 32.");


			tileID.push({id:65280, label:"grass", type:Grass});
			tileID.push({id:255, label:"water", type:Water});
			tileID.push({id:16771455, label:"sand", type:Sand});
			tileID.push({id:12632256, label:"waterrock", type:WaterRock});
			tileID.push({id:36095, label:"freshwater", type:FreshWater});

			entID.push({id:32526, label:"palme"});
			entID.push({id:5996288, label:"tree"});
			entID.push({id:145161, label:"pinetree"});
			entID.push({id:65280, label:"pinetree2"});
			entID.push({id:255, label:"jungletree"});
			entID.push({id:36095, label:"brokenboat"});
			
			
			
			//Recipe: item 1, item 2, result
			recipe.push(new Array({type:Trunk, amount:3}, {type:Branch, amount:5}, {type:Gapahuk, amount:1, desc:"Gapahuk"}));
			recipe.push(new Array({type:Stone, amount:5}, {type:Trunk, amount:3}, {type:CampFire, amount:1, desc:"Camp Fire"}));
			recipe.push(new Array({type:Stone, amount:0}, {type:Coconut, amount:1}, {type:OpenCoconut, amount:1, desc:"Open coconut"}));
			recipe.push(new Array({type:OpenCoconut, amount:1}, {type:null, amount:0}, {type:UsableAction, amount:0, desc:"Drink coconut milk"}));
			recipe.push(new Array({type:Match, amount:1}, {type:null, amount:0}, {type:UsableAction, amount:0, desc:"Ignite"}));
			recipe.push(new Array({type:Apple, amount:1}, {type:null, amount:0}, {type:UsableAction, amount:0, desc:"Eat apple"}));
			recipe.push(new Array({type:RawMeat, amount:1}, {type:null, amount:0}, {type:UsableAction, amount:0, desc:"Eat raw meat"}));
			recipe.push(new Array({type:Meat, amount:1}, {type:null, amount:0}, {type:UsableAction, amount:0, desc:"Eat meat"}));
			recipe.push(new Array({type:Branch, amount:1}, {type:Flint, amount:0}, {type:Stick, amount:1, desc:"Make stick"}));
			recipe.push(new Array({type:Branch, amount:1}, {type:Axe, amount:0}, {type:Stick, amount:1, desc:"Make stick"}));
			recipe.push(new Array({type:Stick, amount:1}, {type:Flint, amount:1}, {type:Axe, amount:1, desc:"Make axe"}));
			recipe.push(new Array({type:Trunk, amount:1}, {type:Axe, amount:0}, {type:Wood, amount:1, desc:"Chop"}));
			recipe.push(new Array({type:Wood, amount:5}, {type:Stick, amount:3}, {type:Bridge, amount:1, desc:"Bridge"}));
			recipe.push(new Array({type:Flint, amount:0}, {type:Coconut, amount:1}, {type:OpenCoconut, amount:1, desc:"Open coconut"}));
			recipe.push(new Array({type:Axe, amount:0}, {type:Coconut, amount:1}, {type:OpenCoconut, amount:1, desc:"Open coconut"}));
			recipe.push(new Array({type:Wood, amount:3}, {type:Vine, amount:2}, {type:Bucket, amount:1, desc:"Make bucket"}));
			recipe.push(new Array({type:Stick, amount:7}, {type:Vine, amount:4}, {type:Trap, amount:1, desc:"Set trap"}));
			recipe.push(new Array({type:WaterCoconut, amount:1}, {type:null, amount:0}, {type:UsableAction, amount:0, desc:"Drink water"}));



			energyTick.start();
			scoreTimer.start();
			score.hours = 0;
			score.minutes = 0;
			score.seconds = 0;


			spiller.plassering((608/2)-(spiller.width/2)+32+(spawnPoint.x*32),(608/2)-(spiller.height/2)+32+(spawnPoint.y*32),1);
			spiller.vel = scrollSpeed;
			spiller.xCord = spawnPoint.x + ((viewDist-1)/2);
			spiller.yCord = spawnPoint.y + ((viewDist-1)/2);
			
			infoText.x = 100 + (spawnPoint.x * 32);
			infoText.y = 32 + (spawnPoint.y * 32);
			infoText.width = 200;
			infoText.height = 30;
			infoText.text = "X:" + spiller.xCord + "   Y:" + spiller.yCord;



			inventory.x = (spawnPoint.x+1) * 32;
			inventory.y = (spawnPoint.y+1) * 32;
			inventory.addEventListener(Event.CHANGE, drop);
			
			inventory.lslot.addEventListener(Event.CHANGE, checkRecipe);
			inventory.rslot.addEventListener(Event.CHANGE, checkRecipe);
			window.addEventListener(Event.CHANGE, addCraftedItem);
			inventory.statusVindu.addEventListener(Event.CHANGE, die);


			//staticObjects.push(overlay);
			//staticObjects.push(miniMap);
			//staticObjects.push(infoText);
			staticObjects.push(inventory);
			staticObjects.push(window);

			window.alpha = 0;

			scanMap();
			correctMap();
			drawMap();
			//game.miniMapInit();
			addPlayer(0);
			addStaticObjects();
			
			startTime = getTimer();
			
			//Spillet er klart:
			//-------------------------------------------------------------------------
			
			
			//dropItems(playerFaceDir("x"), playerFaceDir("y"), Wood, 12);
			//dropItems(playerFaceDir("x"), playerFaceDir("y"), Stick, 12);
			//dropItems(playerFaceDir("x"), playerFaceDir("y"), Branch, 10);
			//dropItems(playerFaceDir("x"), playerFaceDir("y"), Vine, 10);
			//dropItems(playerFaceDir("x"), playerFaceDir("y"), Trunk, 20);
			//dropItems(playerFaceDir("x"), playerFaceDir("y"), EmptyCoconut, 10);
			//dropItems(playerFaceDir("x"), playerFaceDir("y"), Axe, 1);
			//dropItems(playerFaceDir("x"), playerFaceDir("y"), Apple, 1);
			//dropItems(playerFaceDir("x"), playerFaceDir("y"), Bucket, 1);
			//dropItems(playerFaceDir("x"), playerFaceDir("y"), Stone, 12);
			//dropItems(playerFaceDir("x"), playerFaceDir("y"), Match, 12);
			//dropItems(playerFaceDir("x"), playerFaceDir("y"), RawMeat, 12);
			
			
			spawnMob(Turtle, 14, 205);
			spawnMob(Turtle, 20, 217);
			spawnMob(Turtle, 44, 240);
			spawnMob(Turtle, 65, 226);
			
			spawnMob(Chicken, 24, 216);
			spawnMob(Chicken, 32, 228);
			spawnMob(Chicken, 46, 215);
			spawnMob(Chicken, 55, 193);
			spawnMob(Chicken, 78, 184);
			spawnMob(Chicken, 42, 183);
			
			
			inventory.toggleInv();
			inventory.statusVindu.editDamage(spiller.damage);
			
			//-------------------------------------------------------------------------
			
			update();
		}
		
		
		private function allowSleep(evt):void{
			sleepTimer.stop();
			sleepTimer.reset();
			canSleep = true;
		}
		
		
		
		private function spawnMob(mobType:Class, xCord:uint, yCord:uint){
			var mob = new mobType();
			mob.pos(xCord, yCord);
			tiles[mob.yy][mob.xx].col = true;
			addChild(mob);
			mob.index = mobs.length;
			mobs.push(mob);
		}
		
		
		
		
		private function allowDrinking(evt){
			canDrink = true;
			drinkTimer.stop();
			drinkTimer.reset();
		}
		
		
		
		function postHighscore(hsString:String):void {
			try {
				var req:URLRequest = new URLRequest(HIGHSCORE_HOST + "?score=" + hsString + "&player=" + playerName);
				trace(req.url);
				var loader:URLLoader = new URLLoader();
				loader.load(req);
			}
			catch (err:Error) {
				trace("Unable to post highscre.");
			}
			
		}
		
		
		
		public function die(evt):void{
			var score_ms:uint = getTimer() - startTime;
			if (highscoreEnabled) {
				postHighscore(score_ms.toString());
			}
			
			sleeping = true;
			scrollSpeed = 0;
			scoreTimer.stop();
			removeChild(spiller);
			removeChild(inventory);
			var tekst:TextField = new TextField();
			var format:TextFormat = new TextFormat();
			var scoreFormat:TextFormat = new TextFormat();
			var scoreTekst:TextField = new TextField();
			
			format.size = 40;
			format.bold = true;
			format.color = 0x000000;
			format.align = "left";
			format.font = "_typewriter";
			scoreFormat.size = 30;
			scoreFormat.bold = true;
			scoreFormat.color = 0x000000;
			scoreFormat.align = "left";
			scoreFormat.font = "_typewriter";
			tekst.selectable = false;
			tekst.border = true;
			tekst.background = true;
			tekst.backgroundColor = 0x990000;
			tekst.text = "GAME OVER!"
			tekst.width = 610;
			tekst.setTextFormat(format);
			tekst.x = spiller.x - (tekst.width/2) + 16;
			tekst.y = spiller.y - 25;
			addChild(tekst);
			setChildIndex(tekst, numChildren - 1);
			
			scoreTekst.selectable = false;
			scoreTekst.text = "You survived: " + makeScoreString();
			scoreTekst.width = 600;
			scoreTekst.setTextFormat(scoreFormat);
			scoreTekst.x = spiller.x - (scoreTekst.width/2) + 16;
			scoreTekst.y = spiller.y + 25;
			addChild(scoreTekst);
			setChildIndex(scoreTekst, numChildren - 1);
			
			
		}
		
		
		
		public function drainEnergyTick(evt):void{
			drainEnergy(-((1/inventory.statusVindu.vitality)*difficulty));
			inventory.statusVindu.editHunger(hungerDrainTick);
			
			//Bevege mobs
			if (mobCheck){
				for (var i=0; i<mobs.length; i++){
					if (Math.random() > 0.7 && !mobs[i].moving){
						var rand:uint = Math.floor(Math.random()*4);
						tiles[mobs[i].yy][mobs[i].xx].col = false;
						if (rand == 0 && !tiles[mobs[i].yy][mobs[i].xx + 1].col) mobs[i].move("right");
						if (rand == 1 && !tiles[mobs[i].yy][mobs[i].xx - 1].col) mobs[i].move("left");
						if (rand == 2 && !tiles[mobs[i].yy - 1][mobs[i].xx].col) mobs[i].move("up");
						if (rand == 3 && !tiles[mobs[i].yy + 1][mobs[i].xx].col) mobs[i].move("down");
						tiles[mobs[i].yy][mobs[i].xx].col = true;
					}
				}
				mobCheck = false;
			}
			else mobCheck = true;
		}
		
		
		public function drainEnergy(val:Number):void{
			var hungerPercent:Number = inventory.statusVindu.hunger / inventory.statusVindu.hungerBar.maxVal;
			
			if (hungerPercent == 0) drainMult = 3;
			else if (hungerPercent > 0 && hungerPercent < 0.5) drainMult = 1;
			else if (hungerPercent >= 0.5 && hungerPercent < 0.9) drainMult = 0.5;
			else drainMult = 0.1;
			
			inventory.statusVindu.editEnergy(val * drainMult);
		}
		
		
		
		public function scoreTick(evt):void{
			score.seconds ++;
			if (score.seconds == 60){
				score.minutes++;
				score.seconds = 0;
				if(inventory.statusVindu.vitality > 1)inventory.statusVindu.editVitality(-1);
				if(score.minutes == 60){
					score.hours ++;
					score.minutes = 0;
				}
			}
			
			inventory.statusVindu.editTime(makeScoreString());
			scoreTimer.start();
		}
		
		public function makeScoreString():String{
			var min:String;
			var hour:String;
			var sec:String;
			
			if (score.seconds <= 9) sec = "0" + String(score.seconds);
			else sec = String(score.seconds);
			
			if (score.minutes <= 9) min = "0" + String(score.minutes);
			else min = String(score.minutes);
			
			hour = "0" + String(score.hours);
				
			var a:String = hour + ":" + min + ":" + sec;
			return a;
		}
		
		
		
		public function voila():void{
			trace("Voila!");
		}
		
		
		
		public function makeEffect(type:Class):void{
			var xx:uint = spiller.xCord;
			var yy:uint = spiller.yCord;
			var effect = new type(xx,yy,spiller.faceDir);
			var effectTimer:Timer = new Timer(5000);
			addChild(effect);
			effectTimer.addEventListener(TimerEvent.TIMER, remove);
			effectTimer.start();
			
			function remove(evt):void{
				removeChild(effect);
				effectTimer.stop();
			}
		}
		
		
		public function checkAllTraps():void{
			var trapXPos:Number;
			var trapYPos:Number;
			for (var trapI = 0; trapI < entities.length; trapI++){
				for (var trapJ = 0; trapJ < entities[trapI].length; trapJ++){
					if (entities[trapI][trapJ] != null){
						if (entities[trapI][trapJ].label == "trap" && entities[trapI][trapJ].trapCheck()){
							trapXPos = entities[trapI][trapJ].xx;
							trapYPos = entities[trapI][trapJ].yy;
							removeChild(entities[trapI][trapJ]);
							entities[trapI][trapJ] = new TrapClosed();
							entities[trapI][trapJ].pos(trapXPos, trapYPos);
							entities[trapI][trapJ].addEventListener(Event.CHANGE, runLocEvent);
							addChild(entities[trapI][trapJ]);
							trace(trapXPos);
							trace(trapYPos);
						}
					}
				}
			}
		}
		
		
		
		public function checkRecipe(evt):void{
			var a = inventory.lslot;
			var b = inventory.rslot;
			
			var aAmount:int;
			var bAmount:int;
			
			window.clearWindow();
			
			for (var i=0; i<recipe.length; i++){
				if ((recipe[i][0].type == a.type && recipe[i][1].type == b.type) || (recipe[i][0].type == b.type && recipe[i][1].type == a.type)){
					if (a.type == recipe[i][0].type){
						aAmount = recipe[i][0].amount;
						bAmount = recipe[i][1].amount;
					}
					else{
						aAmount = recipe[i][1].amount;
						bAmount = recipe[i][0].amount;
					}
					var aTekst:String = "";
					var bTekst:String = "";
					if (a.mc != null) aTekst = a.mc.label;
					if (b.mc != null) bTekst = b.mc.label;
					window.addAction(aAmount + " " + aTekst + " + " + bAmount + " " + bTekst, (a.amount >= aAmount && b.amount >= bAmount), recipe[i][2].type, recipe[i][2].amount, aAmount, bAmount, recipe[i][2].desc, recipe[i][0].type);
				}
				if (i == recipe.length - 1 && window.actions.length == 0){
					window.clearWindow();
				}
			}
			
			updateDamage();
			
		}
		
		
		
		private function updateDamage():void{
			//Setter damage hvis equipped tool
			var tool = inventory.equippedTool();
			
			if (tool != null){
				var aa = new tool();
				spiller.damage = (inventory.statusVindu.strength/2) * aa.multiplier;
			}
			else spiller.damage = inventory.statusVindu.strength / 2;
			
			inventory.statusVindu.editDamage(spiller.damage);
		}
		
		
		
		public function playerFaceDir(dim:String):uint{
			var cord:uint;
			
			if (dim == "x"){
				cord = spiller.xCord;
				if (spiller.faceDir=="left") cord--;
				if (spiller.faceDir=="right") cord++;
			}
			
			if (dim == "y"){
				cord = spiller.yCord;
				if (spiller.faceDir=="up") cord--;
				if (spiller.faceDir=="down") cord++;
			}
			return cord;
		}
		
		
		
		
		//Spesialtilpassede events ved CRAFTING
		//NB! resultatet av crafting må være UsableAction for at det kjøres her
		public function doActions(actionType:Class):void{
						
			var type = new actionType();
			
			inventory.statusVindu.editEnergy(type.actions.energy);
			inventory.statusVindu.editHunger(type.actions.hunger);
			
			function removeEnergy():void{
				inventory.statusVindu.editEnergy(-type.actions.energy);
				inventory.statusVindu.editHunger(-type.actions.hunger);
			}
			
			//match
			if (type.label == "match"){
				var xx:uint = playerFaceDir("x");
				var yy:uint = playerFaceDir("y");
				var ent = entities[yy][xx];
				makeEffect(Flame);
				if (ent != null){
					if (ent.label == "campfire"){
						var campFire = new CampFireOn();
						campFire.addEventListener(Event.CHANGE, runLocEvent);
						campFire.x = ent.x;
						campFire.y = ent.y;
						removeChild(ent);
						entities[yy][xx] = campFire;
						addChild(campFire);
					}
				}
			}
			
			//Open coconut
			if (type.label == "opencoconut") inventory.additem(EmptyCoconut);
			
			//Water coconut
			if (type.label == "watercoconut"){
				if (Math.random() > 0.2) inventory.additem(EmptyCoconut);
				if (canDrink){
					canDrink = false;
					drinkTimer.start();
				}
				else removeEnergy();
			}
			
		}
		
		
		
		//Actions ved hitting (space)
		public function useAction():void {
			if (!sleeping){
				var xCord:uint = playerFaceDir("x");
				var yCord:uint = playerFaceDir("y");
				var tile = tiles[yCord][xCord];
				
				swingArm();
				hit();
				
				//stone
				if (tile.item != null){
					dropItems(xCord, yCord, tile.dropItem, tile.dropItemAmount)
					tile.removeChild(tile.item);
					tile.item = null;
				}
				
				//empty coconut
				if (tile.freshWater && inventory.equipped(EmptyCoconut,null)){
					inventory.removeitem(EmptyCoconut, 1);
					inventory.additem(WaterCoconut);
				}
				//Bucket
				if (tile.freshWater && inventory.equipped(Bucket,null)){
					inventory.removeitem(Bucket, 1);
					inventory.additem(WaterBucket);
				}
				
			}
		}
		
		
		
		
		public function addCraftedItem(evt){
			if (window.craftedItem.type != null){
				var crafted = new window.craftedItem.type();
				if (crafted.classification == "item"){
					for (var i=0; i<window.craftedItem.amount; i++) inventory.additem(crafted.type);
					pay();
				}
				
				if (crafted.classification == "usable"){
					doActions(window.craftedItem.actionType);
					pay();
				}
				
				if (crafted.classification == "entity"){
					crafted.addEventListener(Event.CHANGE, runLocEvent);
										
					spiller.setHighlight = true;
		
					//Høyre
					if (entities[spiller.yCord][spiller.xCord + 1] == null && !tiles[spiller.yCord][spiller.xCord + 1].col){
						entities[spiller.yCord][spiller.xCord + 1] = new Highlight();
						addChild(entities[spiller.yCord][spiller.xCord + 1])
						entities[spiller.yCord][spiller.xCord + 1].x = spiller.x + 32;
						entities[spiller.yCord][spiller.xCord + 1].y = spiller.y;
						entities[spiller.yCord][spiller.xCord + 1].addEventListener(MouseEvent.CLICK, highlightHKlikk);
						
					}
						
					//Venstre
					if (entities[spiller.yCord][spiller.xCord - 1] == null && !tiles[spiller.yCord][spiller.xCord - 1].col){
						entities[spiller.yCord][spiller.xCord - 1] = new Highlight();
						addChild(entities[spiller.yCord][spiller.xCord - 1])
						entities[spiller.yCord][spiller.xCord - 1].x = spiller.x - 32;
						entities[spiller.yCord][spiller.xCord - 1].y = spiller.y;
						entities[spiller.yCord][spiller.xCord - 1].addEventListener(MouseEvent.CLICK, highlightVKlikk);
							
					}
						
					//Opp
					if (entities[spiller.yCord - 1][spiller.xCord] == null && !tiles[spiller.yCord - 1][spiller.xCord].col){
						entities[spiller.yCord - 1][spiller.xCord] = new Highlight();
						addChild(entities[spiller.yCord - 1][spiller.xCord])
						entities[spiller.yCord - 1][spiller.xCord].x = spiller.x;
						entities[spiller.yCord - 1][spiller.xCord].y = spiller.y - 32;
						entities[spiller.yCord - 1][spiller.xCord].addEventListener(MouseEvent.CLICK, highlightUKlikk);
						
					}
						
					//Ned
					if (entities[spiller.yCord + 1][spiller.xCord] == null && !tiles[spiller.yCord + 1][spiller.xCord].col){
						entities[spiller.yCord + 1][spiller.xCord] = new Highlight();
						addChild(entities[spiller.yCord + 1][spiller.xCord])
						entities[spiller.yCord + 1][spiller.xCord].x = spiller.x;
						entities[spiller.yCord + 1][spiller.xCord].y = spiller.y + 32;
						entities[spiller.yCord + 1][spiller.xCord].addEventListener(MouseEvent.CLICK, highlightDKlikk);
					}
						
					else spiller.setHighlight = false;
						
				}
				if(crafted.classification == "tile"){
					//Opp
					if ((tiles[spiller.yCord - 1][spiller.xCord].label == "water" || tiles[spiller.yCord - 1][spiller.xCord].label == "waterBorder" ) && (tiles[spiller.yCord][spiller.xCord].label == "grass" || tiles[spiller.yCord][spiller.xCord].label == "bridge" || tiles[spiller.yCord][spiller.xCord].label == "sand")){
						entities[spiller.yCord - 1][spiller.xCord] = new Highlight();
						addChild(entities[spiller.yCord - 1][spiller.xCord])
						entities[spiller.yCord - 1][spiller.xCord].x = spiller.x;
						entities[spiller.yCord - 1][spiller.xCord].y = spiller.y - 32;
						entities[spiller.yCord - 1][spiller.xCord].addEventListener(MouseEvent.CLICK, highlightUKlikk);
						
					}
					//Ned
					if ((tiles[spiller.yCord + 1][spiller.xCord].label == "water" || tiles[spiller.yCord + 1][spiller.xCord].label == "waterBorder") && (tiles[spiller.yCord][spiller.xCord].label == "grass" || tiles[spiller.yCord][spiller.xCord].label == "bridge" || tiles[spiller.yCord][spiller.xCord].label == "sand")){
						entities[spiller.yCord + 1][spiller.xCord] = new Highlight();
						addChild(entities[spiller.yCord + 1][spiller.xCord])
						entities[spiller.yCord + 1][spiller.xCord].x = spiller.x;
						entities[spiller.yCord + 1][spiller.xCord].y = spiller.y + 32;
						entities[spiller.yCord + 1][spiller.xCord].addEventListener(MouseEvent.CLICK, highlightDKlikk);
						
					}
					//Venstre
					if ((tiles[spiller.yCord][spiller.xCord - 1].label == "water" || tiles[spiller.yCord][spiller.xCord - 1].label == "waterBorder" ) && (tiles[spiller.yCord][spiller.xCord].label == "grass" || tiles[spiller.yCord][spiller.xCord].label == "bridge" || tiles[spiller.yCord][spiller.xCord].label == "sand")){
						entities[spiller.yCord][spiller.xCord - 1] = new Highlight();
						addChild(entities[spiller.yCord][spiller.xCord - 1])
						entities[spiller.yCord][spiller.xCord - 1].x = spiller.x - 32;
						entities[spiller.yCord][spiller.xCord - 1].y = spiller.y;
						entities[spiller.yCord][spiller.xCord - 1].addEventListener(MouseEvent.CLICK, highlightVKlikk);
						
					}
					//Høyre
					if ((tiles[spiller.yCord][spiller.xCord + 1].label == "water" || tiles[spiller.yCord][spiller.xCord + 1].label == "waterBorder") && (tiles[spiller.yCord][spiller.xCord].label == "grass" || tiles[spiller.yCord][spiller.xCord].label == "bridge" || tiles[spiller.yCord][spiller.xCord].label == "sand")){
						entities[spiller.yCord][spiller.xCord + 1] = new Highlight();
						addChild(entities[spiller.yCord][spiller.xCord + 1])
						entities[spiller.yCord][spiller.xCord + 1].x = spiller.x + 32;
						entities[spiller.yCord][spiller.xCord + 1].y = spiller.y;
						entities[spiller.yCord][spiller.xCord + 1].addEventListener(MouseEvent.CLICK, highlightHKlikk);
						
					}
					else spiller.setHighlight = false;
				}
					function highlightHKlikk (evt):Boolean{
						removeHighlights ();
						crafted.pos(spiller.xCord+1,spiller.yCord);
						if(crafted.classification == "entity"){
							entities[crafted.yy][crafted.xx] = crafted;
						}
						else {
							crafted = new BridgeHori();
							crafted.pos(spiller.xCord+1,spiller.yCord);
							tiles[crafted.yy][crafted.xx] = crafted;
						}
						tiles[crafted.yy][crafted.xx].col = crafted.col;
						addChild(crafted);
						update();
						pay();
						checkRecipe(MouseEvent);
						return true
					}
					
					function highlightVKlikk (evt):Boolean{
						removeHighlights ();
						crafted.pos(spiller.xCord-1,spiller.yCord);
						if(crafted.classification == "entity"){
							entities[crafted.yy][crafted.xx] = crafted;
						}
						else {
							crafted = new BridgeHori();
							crafted.pos(spiller.xCord-1,spiller.yCord);
							tiles[crafted.yy][crafted.xx] = crafted;
						}
						tiles[crafted.yy][crafted.xx].col = crafted.col;
						addChild(crafted);
						update();
						pay();
						checkRecipe(MouseEvent);
						return true
					}
					
					function highlightUKlikk (evt):Boolean{
						removeHighlights ();
						crafted.pos(spiller.xCord,spiller.yCord-1);
						if(crafted.classification == "entity"){
							entities[crafted.yy][crafted.xx] = crafted;
						}
						else {
							tiles[crafted.yy][crafted.xx] = crafted;
						}
						tiles[crafted.yy][crafted.xx].col = crafted.col;
						addChild(crafted);
						update();
						pay();
						checkRecipe(MouseEvent);
						return true
					}
					
					function highlightDKlikk (evt):Boolean{
						removeHighlights ();
						crafted.pos(spiller.xCord,spiller.yCord+1);
						if(crafted.classification == "entity"){
							entities[crafted.yy][crafted.xx] = crafted;
						}
						else {
							tiles[crafted.yy][crafted.xx] = crafted;
						}
						tiles[crafted.yy][crafted.xx].col = crafted.col;
						addChild(crafted);
						update();
						pay();
						checkRecipe(MouseEvent);
						return true
					}
					
					
					function pay():void{
						inventory.pay(window.craftedItem.lPrice, window.craftedItem.rPrice);
					}
					
					function removeHighlights (){
						if(entities[spiller.yCord][spiller.xCord + 1] != null && entities[spiller.yCord][spiller.xCord + 1].label == "highlight"){
							entities[spiller.yCord][spiller.xCord + 1].removeEventListener(MouseEvent.CLICK, highlightHKlikk)
							removeChild(entities[spiller.yCord][spiller.xCord + 1]);
							entities[spiller.yCord][spiller.xCord + 1] = null;
						}
						if(entities[spiller.yCord][spiller.xCord - 1] != null && entities[spiller.yCord][spiller.xCord - 1].label == "highlight"){
							entities[spiller.yCord][spiller.xCord - 1].removeEventListener(MouseEvent.CLICK, highlightVKlikk)
							removeChild(entities[spiller.yCord][spiller.xCord - 1]);
							entities[spiller.yCord][spiller.xCord - 1] = null;
						}
						if(entities[spiller.yCord -1][spiller.xCord] != null  && entities[spiller.yCord - 1][spiller.xCord].label == "highlight"){
							entities[spiller.yCord - 1][spiller.xCord].removeEventListener(MouseEvent.CLICK, highlightUKlikk)
							removeChild(entities[spiller.yCord - 1][spiller.xCord]);
							entities[spiller.yCord - 1][spiller.xCord] = null;
						}
						if(entities[spiller.yCord + 1][spiller.xCord ] != null && entities[spiller.yCord + 1][spiller.xCord].label == "highlight"){
							entities[spiller.yCord + 1][spiller.xCord].removeEventListener(MouseEvent.CLICK, highlightDKlikk)
							removeChild(entities[spiller.yCord + 1][spiller.xCord]);
							entities[spiller.yCord + 1][spiller.xCord] = null;
						}
						spiller.setHighlight = false;
				
					}
					
				checkRecipe(MouseEvent);
				
			}
		}
		
		
		
		
		public function drop(evt):void {
			var xCord:int = playerFaceDir("x");
			var yCord:int = playerFaceDir("y");
			dropItems(xCord, yCord, inventory.temp.type, inventory.temp.amount);
		}
		




		public function miniMapInit():void {
			miniMap.pos.x = (spawnPoint.x*256)/mapSize.x;
			miniMap.pos.y = (spawnPoint.y*256)/mapSize.y;
			miniMap.x = 40 + (spawnPoint.x * 32);
			miniMap.y = 40 + (spawnPoint.y * 32);
			miniMap.scaleX = 0.5;
			miniMap.scaleY = 0.5;
		}




		public function drawMap():void {
			//tegne tiles
			for (var k=spawnPoint.y; k<viewDist + spawnPoint.y; k++) {
				for (var i=spawnPoint.x; i<viewDist + spawnPoint.x; i++) {
					addChild(tiles[k][i]);
				}
			}
			//tegne entities
			for (var kk=spawnPoint.y; kk<viewDist + spawnPoint.y; kk++) {
				for (var ii=spawnPoint.x; ii<viewDist + spawnPoint.x; ii++) {
					if (entities[kk][ii] != null) {
						addChild(entities[kk][ii]);
						entsInRange.push(entities[kk][ii]);
					}
				}
			}
			x -= 32 + (spawnPoint.x * 32);
			y -= 32 + (spawnPoint.y * 32);
			currentX=spawnPoint.x;
			currentY=spawnPoint.y;
		}





		public function updateMiniMap(currentX:int, currentY:int):void {
			miniMap.pos.x = (currentX*256)/mapSize.x;
			miniMap.pos.y = (currentY*256)/mapSize.y;
		}




		public function updateInfo():void {
			infoText.text="X:"+spiller.xCord+"   Y:"+spiller.yCord;
		}




		//Scan map.png og legger til tile i tiles
		public function scanMap():void {
			for (var k=0; k<mapSize.y; k++) {
				tiles.push(new Array());
				entities.push(new Array());
				for (var i=0; i<mapSize.x; i++) {
					//Scanning av map
					for (var id=0; id<tileID.length; id++) {
						var rgbId:uint = mapData.getPixel(i,k);
						if (rgbId == tileID[id].id) {
							setTile(i,k,tileID[id].type);
							if (rgbId == 36095){
								tiles[k][i].freshWater = true;
							}
							break;
						}
						if (id == tileID.length-1 && tiles[k][i] == null) {
							trace("Unknown tile RGB id (" + mapData.getPixel(i,k) + ") at (" + i + "," + k + ")");
							setTile(i,k,BlankTile);
						}
					}
					//Scanning av ent
					for (var ide=0; ide<entID.length; ide++) {
						if (entData.getPixel(i,k)==entID[ide].id) {
							setEnt(i,k,entID[ide]);
						}
					}
				}
			}
		}
		



		//Ferdiggjør map (shores osv)
		public function correctMap():void {
			for (var k=0; k<mapSize.y; k++) {
				for (var i=0; i<mapSize.x; i++) {
					var tile={x:int,y:int,type:Class};

					//ShoreDownLeft
					if (k>0&&i<mapSize.y-2) {
						if (tiles[k][i].label=="water"&&tiles[k-1][i].label=="water"&&tiles[k][i+1].label=="water"&&tiles[k-1][i+1].label=="grass") {
							tile.x=i;
							tile.y=k;
							tile.type=ShoreDownLeft;
							tempTiles.push(tile);
						}
					}
					
					//WaterToSandDownLeft
					if (k>0&&i<mapSize.y-2) {
						if (tiles[k][i].label=="water"&&tiles[k-1][i].label=="water"&&tiles[k][i+1].label=="water"&&tiles[k-1][i+1].label=="sand") {
							tile.x=i;
							tile.y=k;
							tile.type=WaterToSandDownLeft;
							tempTiles.push(tile);
						}
					}

					//GrassToSandDownLeft
					if (k>0&&i<mapSize.y-2) {
						if (tiles[k][i].label=="grass"&&tiles[k-1][i].label=="grass"&&tiles[k][i+1].label=="grass"&&tiles[k-1][i+1].label=="sand") {
							tile.x=i;
							tile.y=k;
							tile.type=GrassToSandDownLeft;
							tempTiles.push(tile);
						}
					}

					//ShoreDownRight
					if (k>0&&i>0) {
						if (tiles[k][i].label=="water"&&tiles[k-1][i].label=="water"&&tiles[k][i-1].label=="water"&&tiles[k-1][i-1].label=="grass") {
							tile.x=i;
							tile.y=k;
							tile.type=ShoreDownRight;
							tempTiles.push(tile);
						}
					}
					
					//WaterToSandDownRight
					if (k>0&&i>0) {
						if (tiles[k][i].label=="water"&&tiles[k-1][i].label=="water"&&tiles[k][i-1].label=="water"&&tiles[k-1][i-1].label=="sand") {
							tile.x=i;
							tile.y=k;
							tile.type=WaterToSandDownRight;
							tempTiles.push(tile);
						}
					}

					//GrasstoSandDownRight
					if (k>0&&i>0) {
						if (tiles[k][i].label=="grass"&&tiles[k-1][i].label=="grass"&&tiles[k][i-1].label=="grass"&&tiles[k-1][i-1].label=="sand") {
							tile.x=i;
							tile.y=k;
							tile.type=GrassToSandDownRight;
							tempTiles.push(tile);
						}
					}

					//ShoreInnerDownLeft
					if (i<mapSize.x-1&&k>0) {
						if (tiles[k][i].label=="water"&&tiles[k-1][i].label=="grass"&&tiles[k][i+1].label=="grass"&&tiles[k-1][i+1].label=="grass") {
							tile.x=i;
							tile.y=k;
							tile.type=ShoreInnerDownLeft;
							tempTiles.push(tile);
						}
					}
					
					//WaterToSandInnerDownLeft
					if (i<mapSize.x-1&&k>0) {
						if (tiles[k][i].label=="water"&&tiles[k-1][i].label=="sand"&&tiles[k][i+1].label=="sand"&&tiles[k-1][i+1].label=="sand") {
							tile.x=i;
							tile.y=k;
							tile.type=WaterToSandInnerDownLeft;
							tempTiles.push(tile);
						}
					}

					//GrassToSandInnerDownLeft
					if (i<mapSize.x-1&&k>0) {
						if (tiles[k][i].label=="grass"&&tiles[k-1][i].label=="sand"&&tiles[k][i+1].label=="sand"&&tiles[k-1][i+1].label=="sand") {
							tile.x=i;
							tile.y=k;
							tile.type=GrassToSandInnerDownLeft;
							tempTiles.push(tile);
						}
					}

					//ShoreInnerDownRight
					if (i>0&&k>0) {
						if (tiles[k][i].label=="water"&&tiles[k-1][i].label=="grass"&&tiles[k][i-1].label=="grass"&&tiles[k-1][i-1].label=="grass") {
							tile.x=i;
							tile.y=k;
							tile.type=ShoreInnerDownRight;
							tempTiles.push(tile);
						}
					}
					
					//WaterToSandInnerDownRight
					if (i>0&&k>0) {
						if (tiles[k][i].label=="water"&&tiles[k-1][i].label=="sand"&&tiles[k][i-1].label=="sand"&&tiles[k-1][i-1].label=="sand") {
							tile.x=i;
							tile.y=k;
							tile.type=WaterToSandInnerDownRight;
							tempTiles.push(tile);
						}
					}

					//GrassToSandInnerDownRight
					if (i>0&&k>0) {
						if (tiles[k][i].label=="grass"&&tiles[k-1][i].label=="sand"&&tiles[k][i-1].label=="sand"&&tiles[k-1][i-1].label=="sand") {
							tile.x=i;
							tile.y=k;
							tile.type=GrassToSandInnerDownRight;
							tempTiles.push(tile);
						}
					}

					//ShoreOuterTopLeft
					if (i<mapSize.x-1&&k<mapSize.y-1) {
						if (tiles[k][i].label=="water"&&tiles[k+1][i].label=="water"&&tiles[k][i+1].label=="water"&&tiles[k+1][i+1].label=="grass") {
							tile.x=i;
							tile.y=k;
							tile.type=ShoreOuterTopLeft;
							tempTiles.push(tile);
						}
					}
					
					//WaterToSandOuterTopLeft
					if (i<mapSize.x-1&&k<mapSize.y-1) {
						if (tiles[k][i].label=="water"&&tiles[k+1][i].label=="water"&&tiles[k][i+1].label=="water"&&tiles[k+1][i+1].label=="sand") {
							tile.x=i;
							tile.y=k;
							tile.type=WaterToSandOuterTopLeft;
							tempTiles.push(tile);
						}
					}

					//GrassToSandOuterTopLeft
					if (i<mapSize.x-1&&k<mapSize.y-1) {
						if (tiles[k][i].label=="grass"&&tiles[k+1][i].label=="grass"&&tiles[k][i+1].label=="grass"&&tiles[k+1][i+1].label=="sand") {
							tile.x=i;
							tile.y=k;
							tile.type=GrassToSandOuterTopLeft;
							tempTiles.push(tile);
						}
					}

					//ShoreOuterTopRight
					if (i>0&&k<mapSize.y-1) {
						if (tiles[k][i].label=="water"&&tiles[k+1][i].label=="water"&&tiles[k][i-1].label=="water"&&tiles[k+1][i-1].label=="grass") {
							tile.x=i;
							tile.y=k;
							tile.type=ShoreOuterTopRight;
							tempTiles.push(tile);
						}
					}
					
					//WaterToSandOuterTopRight
					if (i>0&&k<mapSize.y-1) {
						if (tiles[k][i].label=="water"&&tiles[k+1][i].label=="water"&&tiles[k][i-1].label=="water"&&tiles[k+1][i-1].label=="sand") {
							tile.x=i;
							tile.y=k;
							tile.type=WaterToSandOuterTopRight;
							tempTiles.push(tile);
						}
					}

					//GrassToSandOuterTopRight
					if (i>0&&k<mapSize.y-1) {
						if (tiles[k][i].label=="grass"&&tiles[k+1][i].label=="grass"&&tiles[k][i-1].label=="grass"&&tiles[k+1][i-1].label=="sand") {
							tile.x=i;
							tile.y=k;
							tile.type=GrassToSandOuterTopRight;
							tempTiles.push(tile);
						}
					}

					//ShoreInnerUpLeft
					if (i<mapSize.x-1&&k<mapSize.y-1) {
						if (tiles[k][i].label=="water"&&tiles[k+1][i].label=="grass"&&tiles[k][i+1].label=="grass"&&tiles[k+1][i+1].label=="grass") {
							tile.x=i;
							tile.y=k;
							tile.type=ShoreInnerUpLeft;
							tempTiles.push(tile);
						}
					}
					
					//WaterToSandInnerUpLeft
					if (i<mapSize.x-1&&k<mapSize.y-1) {
						if (tiles[k][i].label=="water"&&tiles[k+1][i].label=="sand"&&tiles[k][i+1].label=="sand"&&tiles[k+1][i+1].label=="sand") {
							tile.x=i;
							tile.y=k;
							tile.type=WaterToSandInnerUpLeft;
							tempTiles.push(tile);
						}
					}

					//GrassToSandInnerUpLeft
					if (i<mapSize.x-1&&k<mapSize.y-1) {
						if (tiles[k][i].label=="grass"&&tiles[k+1][i].label=="sand"&&tiles[k][i+1].label=="sand"&&tiles[k+1][i+1].label=="sand") {
							tile.x=i;
							tile.y=k;
							tile.type=GrassToSandInnerUpLeft;
							tempTiles.push(tile);
						}
					}


					//ShoreInnerUpRight
					if (i>0&&k<mapSize.y-1) {
						if (tiles[k][i].label=="water"&&tiles[k+1][i].label=="grass"&&tiles[k][i-1].label=="grass"&&tiles[k+1][i-1].label=="grass") {
							tile.x=i;
							tile.y=k;
							tile.type=ShoreInnerUpRight;
							tempTiles.push(tile);
						}
					}
					
					//WaterToSandInnerUpRight
					if (i>0&&k<mapSize.y-1) {
						if (tiles[k][i].label=="water"&&tiles[k+1][i].label=="sand"&&tiles[k][i-1].label=="sand"&&tiles[k+1][i-1].label=="sand") {
							tile.x=i;
							tile.y=k;
							tile.type=WaterToSandInnerUpRight;
							tempTiles.push(tile);
						}
					}

					//GrassToSandInnerUpRight
					if (i>0&&k<mapSize.y-1) {
						if (tiles[k][i].label=="grass"&&tiles[k+1][i].label=="sand"&&tiles[k][i-1].label=="sand"&&tiles[k+1][i-1].label=="sand") {
							tile.x=i;
							tile.y=k;
							tile.type=GrassToSandInnerUpRight;
							tempTiles.push(tile);
						}
					}

				}
			}
			
			//Legger ut temp tiles
			for (var u=0; u<tempTiles.length; u++) {
				var temp = new tempTiles[u].type();
				tiles[tempTiles[u].y][tempTiles[u].x].label = temp.label;
				tiles[tempTiles[u].y][tempTiles[u].x].addOverlay(tempTiles[u].type);
			}
			tempTiles.splice(0,tempTiles.length);


			//Scanner etter flere tiles
			for (var kk=0; kk<mapSize.y; kk++) {
				for (var ii=0; ii<mapSize.x; ii++) {

					//ShoreLeft
					if (ii<mapSize.x-1) {
						if (tiles[kk][ii].label=="water"&&tiles[kk][ii+1].label=="grass") {
							tiles[kk][ii].addOverlay(ShoreDown, 1);
						}
					}
					
					//WaterToSandLeft
					if (ii<mapSize.x-1) {
						if (tiles[kk][ii].label=="water"&&tiles[kk][ii+1].label=="sand") {
							setTile(ii,kk,WaterToSandLeft);
						}
					}

					//GrassToSandLeft
					if (ii<mapSize.x-1) {
						if (tiles[kk][ii].label=="grass"&&tiles[kk][ii+1].label=="sand") {
							setTile(ii,kk,GrassToSandLeft);
						}
					}

					//ShoreDown
					if (kk>0) {
						if (tiles[kk][ii].label=="water"&&tiles[kk-1][ii].label=="grass") {
							tiles[kk][ii].addOverlay(ShoreDown);
						}
					}
					
					//WaterToSandDown
					if (kk>0) {
						if (tiles[kk][ii].label=="water"&&tiles[kk-1][ii].label=="sand") {
							setTile(ii,kk,WaterToSandDown);
						}
					}

					//GrassToSandDown
					if (kk>0) {
						if (tiles[kk][ii].label=="grass"&&tiles[kk-1][ii].label=="sand") {
							setTile(ii,kk,GrassToSandDown);
						}
					}

					//ShoreRight
					if (ii>0) {
						if (tiles[kk][ii].label=="water"&&tiles[kk][ii-1].label=="grass") {
							tiles[kk][ii].addOverlay(ShoreDown, 3);
						}
					}
					
					//WaterToSandRight
					if (ii>0) {
						if (tiles[kk][ii].label=="water"&&tiles[kk][ii-1].label=="sand") {
							setTile(ii,kk,WaterToSandRight);
						}
					}

					//GrassToSandRight
					if (ii>0) {
						if (tiles[kk][ii].label=="grass"&&tiles[kk][ii-1].label=="sand") {
							setTile(ii,kk,GrassToSandRight);
						}
					}

					//ShoreUp
					if (kk<mapSize.y-1) {
						if (tiles[kk][ii].label=="water"&&tiles[kk+1][ii].label=="grass") {
							tiles[kk][ii].addOverlay(ShoreUp);
						}
					}
					
					//WaterToSandUp
					if (kk<mapSize.y-1) {
						if (tiles[kk][ii].label=="water"&&tiles[kk+1][ii].label=="sand") {
							setTile(ii,kk,WaterToSandUp);
						}
					}

					//GrassToSandUp
					if (kk<mapSize.y-1) {
						if (tiles[kk][ii].label=="grass"&&tiles[kk+1][ii].label=="sand") {
							setTile(ii,kk,GrassToSandUp);
						}
					}

				}
			}

		}




		//Endre/sette en bestemt tile
		public function setTile(xCord:int, yCord:int, type:Class):void {
			var tile = new type();
			tile.pos(xCord,yCord);
			if (tiles[yCord][xCord]!=null) {
				tile.col = tiles[yCord][xCord].col;
				tile.freshWater = tiles[yCord][xCord].freshWater;
			}
			tiles[yCord][xCord] = tile;
		}



		//Endre/sette en bestemt entity
		public function setEnt(xCord:int, yCord:int, type):void {
			if (type.label=="palme") {
				makePalme(xCord, yCord);
			}
			if (type.label=="tree") {
				makeTree(xCord, yCord);
			}
			if (type.label=="pinetree") {
				makePineTree(xCord, yCord);
			}
			if (type.label=="pinetree2") {
				makePineTree2(xCord, yCord);
			}
			if (type.label=="jungletree") {
				makeJungleTree(xCord, yCord);
			}
			if (type.label=="brokenboat") {
				makeBoat(xCord, yCord);
			}
		}




		public function makePalme(xCord:int, yCord:int):void {
			var bunn = new PalmeBunn();
			var topp = new PalmeTopp();
			bunn.pos(xCord,yCord);
			topp.pos(xCord,yCord-1);
			tiles[yCord][xCord].col=true;
			entities[yCord][xCord]=bunn;
			entities[yCord-1][xCord]=topp;
		}




		public function makeTree(xCord:int, yCord:int):void {
			var tree = new Tree();
			tree.pos(xCord,yCord);
			tiles[yCord][xCord].col=true;
			entities[yCord][xCord]=tree;
		}
		
		
		
		public function makeBoat(xCord:int, yCord:int):void {
			var tree = new BrokenBoat();
			tree.addEventListener(Event.CHANGE, runLocEvent);
			tree.pos(xCord,yCord);
			tiles[yCord][xCord].col=true;
			tiles[yCord][xCord - 1].col = true;
			entities[yCord][xCord]=tree;
		}




		public function makePineTree(xCord:int, yCord:int):void {
			var høyde:int=Math.floor(Math.random()*3);
			var bunn=new PineTreeBunn(høyde+2);
			var topp = new PineTreeTopp();
			for (var i=0; i<høyde; i++) {
				var mid = new PineTreeMid();
				mid.pos(xCord,yCord-(i+1));
				entities[yCord-(i+1)][xCord] = mid;
			}
			bunn.pos(xCord,yCord);
			topp.pos(xCord,yCord-høyde-1);
			tiles[yCord][xCord].col=true;
			entities[yCord][xCord]=bunn;
			entities[yCord-høyde-1][xCord]=topp;
		}
		
		
		
		
		public function makePineTree2(xCord:int, yCord:int):void {
			var høyde:int=Math.floor(Math.random()*3 + 1);
			var bunn=new PineTree2Bunn(høyde+2);
			var topp = new PineTree2Topp();
			for (var i=0; i<høyde; i++) {
				var mid = new PineTree2Mid();
				mid.pos(xCord,yCord-(i+1));
				entities[yCord-(i+1)][xCord] = mid;
			}
			bunn.pos(xCord,yCord);
			topp.pos(xCord,yCord-høyde-1);
			tiles[yCord][xCord].col=true;
			entities[yCord][xCord]=bunn;
			entities[yCord-høyde-1][xCord]=topp;
		}
		
		
		
		
		public function makeJungleTree(xCord:int, yCord:int):void {
			var bunn = new JungleTreeBot();
			var topp = new JungleTreeTop();
			bunn.pos(xCord,yCord);
			topp.pos(xCord,yCord - (bunn.høyde - 1));
			tiles[yCord][xCord].col=true;
			entities[yCord][xCord]= bunn;
			entities[yCord-(bunn.høyde - 1)][xCord]= topp;
			
		}




		public function hit():void {
			var xCord:int=playerFaceDir("x");
			var yCord:int=playerFaceDir("y");

			if (entities[yCord][xCord]!=null) {
				var ent=entities[yCord][xCord];
				if (ent.health!=-1) {
					ent.health-=spiller.damage;
					ent.play();
					hitLyd.play();
					if (ent.health <= 0) {
						for (var i=0; i<ent.høyde; i++) {
							tiles[yCord][xCord].col=false;
							removeChild(entities[yCord - i][xCord]);
							entities[ent.yy-i][ent.xx]=null;
						}
						entities[yCord][xCord]=null;
						dropItemsEnt(ent.xx, ent.yy, ent);
					}
				}
				drainEnergy(energyDrainHit * difficulty);
				inventory.statusVindu.editStrength(0.03);
			}
			
			for (var u=0; u<mobs.length; u++){
				if (xCord == mobs[u].xx && yCord == mobs[u].yy){
					if (mobs[u].hurt(spiller.damage)){
						//dropItems(mobs[u].xx, mobs[u].yy, Meat, 2);
						
						for (var j=0; j<mobs[u].dropItems.length; j++){
							dropItems(mobs[u].xx, mobs[u].yy, mobs[u].dropItems[j].type, mobs[u].dropItems[j].amount);
						}
						
						tiles[mobs[u].yy][mobs[u].xx].col = false;
						removeChild(mobs[u]);
						var index:uint = mobs[u].index;
						mobs.splice(index, 1);
						
						for (var k=index; k<mobs.length; k++){
							mobs[k].index--;
						}
						
					}
				}
			}
		}





		public function dropItemsEnt(xCord:int, yCord:int, ent):void {
			for (var i=0; i<ent.dropItems.length; i++) {
				var item = new ent.dropItems[i].type();
				dropItems(xCord, yCord, ent.dropItems[i].type, ent.dropItems[i].amount);
			}
		}
		
		
		
		
		public function dropItems(xCord:int, yCord:int, type, amount):void {
			for (var i=0; i<amount; i++) {
				var item = new type();
				item.xx = xCord;
				item.yy = yCord;
				item.x = (xCord * 32) + 16 + ((Math.random()*20)-10);
				item.y = (yCord * 32) + 16 + ((Math.random()*20)-10);
				addChild(item);
				item.spawn();
				itemList.push(item);
			}
			removeEntities();
			removeItems();
			addPlayer(0);
			addEntities();
			addItems();
			addStaticObjects();
		}




		public function checkItemPickup():void {
			var px:Number = spiller.x + (spiller.width/2);
			var py:Number = spiller.y + (spiller.height/2);
			var ant:uint = 0;
			
			for (var i=0; i<itemList.length; i++) {				
				if (itemList[i].xx == spiller.xCord && itemList[i].yy == spiller.yCord){
					//Hvis plass i inventory
					if (inventory.additem(itemList[i].type)){
						
						if (!pickUpLydSpilt){
							pickUpLyd.play();
							pickUpLydSpilt = true;
						}
						
						checkRecipe(Event);
						removeChild(itemList[i]);
						itemList[i] = null;
						ant++;
					}
				}
				
			}
			if (ant != 0){
				itemList.sort();
				itemList.reverse();
				itemList.splice(0, ant);
			}
		}




		public function knappNed(evt) {
			//trace(evt.keyCode);
			if (!sleeping){
				spiller.tastNed(evt);
				checkLocEvent();
				switch (evt.keyCode) {
					case 68 :
						if (!spiller.setHighlight) { //! left&&! up&&! down && !spiller.setHighlight
							right=true;
							left = false;
							up = false;
							down = false;
						}
						break;
	
					case 65 :
						if (!spiller.setHighlight) { //! right&&! up&&! down && !spiller.setHighlight
							left=true;
							right = false;
							up = false;
							down = false;
						}
						break;
	
					case 87 :
						if (!spiller.setHighlight) {//! right&&! left&&! down && !spiller.setHighlight
							up=true;
							down = false;
							left = false;
							right = false;
						}
						break;
	
					case 83 :
						if (!spiller.setHighlight) {//! right&&! left&&! up && !spiller.setHighlight
							down=true;
							up = false;
							right = false;
							left = false;
						}
						break;
	
					case 32 :
						if(spiller.swingD.hitFinished && spiller.swingU.hitFinished && spiller.swingR.hitFinished && spiller.swingL.hitFinished){
							useAction();
						}
						break;
	
					case 69 :
						inventory.toggleInv();
						break;
	
					case 84 :
						var torch = new Torch();
						torch.x=spiller.xCord*32;
						torch.y=spiller.yCord*32;
						addChild(torch);
						//overlay.addTorch(spiller.xCord, spiller.yCord);
						break;
				}
			}
		}
		
		
		
		
		public function swingArm(){
			if(spiller.faceDir == "down" && spiller.swingD.hitFinished){
				spiller.swingD.gotoAndPlay(2);
				inventory.statusVindu.editEnergy(-0.1);
				swingLyd.play();
			}
			if(spiller.faceDir == "up" && spiller.swingU.hitFinished){
				spiller.swingU.gotoAndPlay(2);
				inventory.statusVindu.editEnergy(-0.1);
				swingLyd.play();
			}
			if(spiller.faceDir == "left" && spiller.swingL.hitFinished){
				spiller.swingL.gotoAndPlay(2);
				inventory.statusVindu.editEnergy(-0.1);
				swingLyd.play();
			}
			if(spiller.faceDir == "right" && spiller.swingR.hitFinished){
				spiller.swingR.gotoAndPlay(2);
				inventory.statusVindu.editEnergy(-0.1);
				swingLyd.play();
			}
		}




		public function knappOpp(evt) {
			if (!sleeping){
				spiller.tastOpp(evt);
				switch (evt.keyCode) {
					case 68 :
						if (right) {
							right=false;
						}
						break;
	
					case 65 :
						if (left) {
							left=false;
						}
						break;
	
					case 87 :
						if (up) {
							up=false;
						}
						break;
	
					case 83 :
						if (down) {
							down=false;
						}
						break;
				}
			}
		}





		private function frame(evt):void {
			//Col og bevegelse sjekk
			if (right||left||up||down) {
				if (right && remainingY == 0 && remainingX == 0 && !tiles[spiller.yCord][spiller.xCord+1].col) {
					tiles[spiller.yCord][spiller.xCord].col = false;
					remainingX=32;
					spiller.xCord++;
					updateInfo();
				}
				if (left && remainingY == 0 && remainingX == 0 && !tiles[spiller.yCord][spiller.xCord-1].col) {
					tiles[spiller.yCord][spiller.xCord].col = false;
					remainingX=-32;
					spiller.xCord--;
					updateInfo();
				}
				if (up && remainingX == 0 && remainingY == 0 && !tiles[spiller.yCord-1][spiller.xCord].col) {
					tiles[spiller.yCord][spiller.xCord].col = false;
					remainingY=-32;
					spiller.yCord--;
					updateInfo();
				}
				if (down && remainingX == 0 && remainingY == 0 && !tiles[spiller.yCord+1][spiller.xCord].col) {
					tiles[spiller.yCord][spiller.xCord].col = false;
					remainingY=32;
					spiller.yCord++;
					updateInfo();
				}
			}
			else if (remainingX == 0 && remainingY == 0) {
				spiller.stopAni();
			}
			//Bevegelse av tiles
			if (remainingX<0 && currentX+Math.abs(xmove)>0) {
				x+=scrollSpeed;
				remainingX+=scrollSpeed;
				xmove+=scrollSpeed;
				for (var u=0; u<staticObjects.length; u++) {
					staticObjects[u].x-=scrollSpeed;
				}
				spiller.x-=scrollSpeed;
			}

			if (remainingX>0 && currentX<mapSize.y-viewDist) {
				x-=scrollSpeed;
				remainingX-=scrollSpeed;
				xmove-=scrollSpeed;
				for (var t=0; t<staticObjects.length; t++) {
					staticObjects[t].x+=scrollSpeed;
				}
				spiller.x+=scrollSpeed;
			}

			if (remainingY<0 && currentY+Math.abs(ymove)>0) {
				y+=scrollSpeed;
				remainingY+=scrollSpeed;
				ymove+=scrollSpeed;
				for (var r=0; r<staticObjects.length; r++) {
					staticObjects[r].y-=scrollSpeed;
				}
				spiller.y-=scrollSpeed;
			}

			if (remainingY>0 && currentY<mapSize.y-viewDist) {
				y-=scrollSpeed;
				remainingY-=scrollSpeed;
				ymove-=scrollSpeed;
				for (var f=0; f<staticObjects.length; f++) {
					staticObjects[f].y+=scrollSpeed;
				}
				spiller.y+=scrollSpeed;
			}


			//Flytte bilde i x-retning
			if (xmove<=-32) {
				removeStaticObjects();
				for (var k=currentY; k<viewDist+currentY; k++) {
					//Fjerner tiles på den ene siden
					removeChild(tiles[k][currentX]);
					if (entities[k][currentX]!=null) {
						removeChild(entities[k][currentX]);
					}//Setter posisjon på nye tiles på motsatt side
					tiles[k][currentX + viewDist].x = tiles[k][currentX + (viewDist-1)].x + 32;
					tiles[k][currentX + viewDist].y = tiles[k][currentX + (viewDist-1)].y;
					//legger til nye tiles og entities
					addChild(tiles[k][currentX + viewDist]);
					if (entities[k][currentX+viewDist]!=null) {
						addChild(entities[k][currentX + viewDist]);
					}
				}
				//overlay.incX(currentX, currentY);
				currentX+=1;
				xmove=0;
				update();
			}
			if (xmove>=32) {
				removeStaticObjects();
				for (var i=currentY; i<viewDist+currentY; i++) {
					removeChild(tiles[i][currentX + (viewDist-1)]);
					if (entities[i][currentX + (viewDist-1)] != null) {
						removeChild(entities[i][currentX + (viewDist-1)]);
					}
					tiles[i][currentX-1].x=tiles[i][currentX].x-32;
					tiles[i][currentX-1].y=tiles[i][currentX].y;
					addChild(tiles[i][currentX - 1]);
					if (entities[i][currentX-1]!=null) {
						addChild(entities[i][currentX - 1]);
					}
				}
				//overlay.decX(currentX, currentY);
				currentX-=1;
				xmove=0;
				update();
			}

			//Flytte bilde i y-retning
			if (ymove<=-32) {
				removeStaticObjects();
				for (var j=currentX; j<viewDist+currentX; j++) {
					removeChild(tiles[currentY][j]);
					if (entities[currentY][j]!=null) {
						removeChild(entities[currentY][j]);
					}
					tiles[currentY + viewDist][j].x = tiles[currentY + (viewDist-1)][j].x;
					tiles[currentY + viewDist][j].y = tiles[currentY + (viewDist-1)][j].y + 32;
					addChild(tiles[currentY + viewDist][j]);
					if (entities[currentY+viewDist][j]!=null) {
						addChild(entities[currentY + viewDist][j]);
					}
				}
				//overlay.incY(currentX, currentY);
				currentY+=1;
				ymove=0;
				update();
			}
			if (ymove>=32) {
				removeStaticObjects();
				for (var h=currentX; h<viewDist+currentX; h++) {
					removeChild(tiles[currentY + (viewDist-1)][h]);
					if (entities[currentY + (viewDist-1)][h] != null) {
						removeChild(entities[currentY + (viewDist-1)][h]);
					}
					tiles[currentY-1][h].x=tiles[currentY][h].x;
					tiles[currentY-1][h].y=tiles[currentY][h].y-32;
					addChild(tiles[currentY - 1][h]);
					if (entities[currentY-1][h]!=null) {
						addChild(entities[currentY - 1][h]);
					}
				}
				//overlay.decY(currentX, currentY);
				currentY-=1;
				ymove=0;
				update();
			}

		}


		
		//Denne funksjonen kjøres etter hver tile spilleren har beveget seg
		public function update():void {
			//updateMiniMap(currentX, currentY);
			
			pickUpLydSpilt = false;
			if (! right&&! left&&! up&&! down) spiller.stopAni();
			
			removeEntities();
			removeItems();
			updateMobs("remove");
			updateMobs("add");
			addPlayer(0);
			addEntities();
			addItems();
			addStaticObjects();
			checkItemPickup();
			updateDamage();
			checkLocEvent();
			
			inventory.statusVindu.editEnergy(energyDrainWalking * (1+(inventory.weight/50)));
			inventory.statusVindu.editStrength(Math.sqrt(inventory.weight)/(inventory.statusVindu.strength * 70));
			
			tiles[spiller.yCord][spiller.xCord].col = true;
			
		}
		
		
		public function checkLocEvent():void{
			if (locEvent) locEvent.removeLocEvent();
			locEvent = null;
			
			var ent = entities[playerFaceDir("y")][playerFaceDir("x")];
			if (ent != null){
				if(ent.hasLocEvent) {
					if (ent.label == "gapahuk") ent.locEventEnabled = canSleep;
					ent.locEvent();
					locEvent = ent;
				}
			}
			
		}
		
		

		public function removeItems():void {
			for (var i=0; i<itemList.length; i++) {
				if (itemList[i]!=null) {
					removeChild(itemList[i]);
				}
			}
		}



		public function addItems():void {
			for (var i=0; i<itemList.length; i++) {
				if (itemList[i]!=null) {
					addChild(itemList[i]);
				}
			}
		}



		public function removeStaticObjects():void {
			for (var aa=0; aa<staticObjects.length; aa++) {
				removeChild(staticObjects[aa]);
			}
		}



		public function addStaticObjects():void {
			for (var ab=0; ab<staticObjects.length; ab++) {
				addChild(staticObjects[ab]);
			}
		}



		public function addPlayer(frame:int):void {
			if (frame==0) {
				addChild(spiller);
			}
		}



		public function removeEntities():void {
			for (var k=currentY; k<viewDist + currentY; k++) {
				for (var i=currentX; i<viewDist + currentX; i++) {
					if (entities[k][i]!=null) {
						removeChild(entities[k][i]);
					}
				}
			}
		}



		public function addEntities():void {
			for (var k=currentY; k<viewDist + currentY; k++) {
				//if (k == spiller.yCord) addPlayer(0);
				for (var i=currentX; i<viewDist + currentX; i++) {
					if (entities[k][i]!=null) {
						addChild(entities[k][i]);
					}
				}
			}
		}
		
		
		
		public function updateMobs(a:String):void{
			if (a == "add"){
				for (var i=0; i<mobs.length; i++){
					addChild(mobs[i]);
				}
			}
			if (a == "remove"){
				for (var u=0; u<mobs.length; u++){
					removeChild(mobs[u]);
				}
			}
			
		}
		
		
		
		
		public function runLocEvent(evt):void{
			
			//GAPAHUK
			if (evt.currentTarget.label == "gapahuk" && canSleep){
				sleeping = true;
				canSleep = false;
				sleepTimer.start();
				var overlay:MovieClip = new MovieClip();
				overlay.graphics.lineStyle(1,0x000000);
				overlay.graphics.beginFill(0x000000);
				overlay.graphics.drawRect(Math.abs(x),Math.abs(y),608,608);
				overlay.alpha = 0;
				addChild(overlay);
				checkAllTraps();
				this.addEventListener(Event.ENTER_FRAME, grad);
				
				function grad(evt){
					if (overlay.alpha < 2) overlay.alpha += 0.02;
					else{
						removeEventListener(Event.ENTER_FRAME, grad);
						inventory.statusVindu.editHunger(-20);
						inventory.statusVindu.editEnergy(10);
						sleeping = false;
						removeChild(overlay);
					}
				}
			}
			
			
			//CLOSED TRAP
			if(evt.currentTarget.label == "trapclosed"){
				dropItems(spiller.xCord, spiller.yCord, RawMeat, Math.floor(Math.random() * 4) + 1);
				var trapXPos = evt.currentTarget.xx;
				var trapYPos = evt.currentTarget.yy;
				removeChild(evt.currentTarget);
				entities[evt.currentTarget.yy][evt.currentTarget.xx] = new Trap();
				entities[evt.currentTarget.yy][evt.currentTarget.xx].pos(trapXPos, trapYPos);
				addChild(entities[evt.currentTarget.yy][evt.currentTarget.xx]);
			}
			
			//CampFire
			if(evt.currentTarget.label == "campfireon"){
				if (inventory.equipped(RawMeat, null)){
					inventory.removeitem(RawMeat, 1);
					inventory.additem(Meat);
				}
				/*if(inventory.rslot.type == RawMeat){
					inventory.removeitem(RawMeat, 1);
					inventory.additem(Meat);
				}
				if(inventory.lslot.type == RawMeat){
					inventory.removeitem(RawMeat, 1);
					inventory.additem(Meat);
				}*/
			}
			
			//BrokenBoat
			if(evt.currentTarget.label == "brokenboat"){
				dropItems(evt.currentTarget.xx, evt.currentTarget.yy, Wood, 4);
				dropItems(evt.currentTarget.xx, evt.currentTarget.yy, Match, 4);
				dropItems(evt.currentTarget.xx, evt.currentTarget.yy, Meat, 1/difficulty);
				tiles[evt.currentTarget.yy][evt.currentTarget.xx].col = false;
				tiles[evt.currentTarget.yy][evt.currentTarget.xx - 1].col = false;
				evt.currentTarget.removeEventListener(Event.CHANGE, runLocEvent);
				entities[evt.currentTarget.yy][evt.currentTarget.xx] = null;
				removeChild(evt.currentTarget);
			}
			
			
			
		}
		
		
		
		
	}
}