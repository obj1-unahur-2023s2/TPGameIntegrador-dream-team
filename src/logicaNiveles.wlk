import wollok.game.*
import consola.*
import nivel1.*
import nivel2.*
import nivel3.*
import juego.*

class LogicaNivel {
	const property audioNivel
	var pantallaNivel
	const property perdisteAudio = game.sound("perdiste.mp3")
	const tanqueNafta1 = new TanqueDeNafta() 
	const tanqueNafta2 = new TanqueDeNafta()
	
	method config(){

		game.clear()
	    audioNivel.shouldLoop(true)
	    keyboard.w().onPressDo({audioNivel.volume(1)})
		keyboard.s().onPressDo({audioNivel.volume(0.5)})
		keyboard.q().onPressDo({audioNivel.volume(0)})
	    game.schedule(500, {audioNivel.play()})
			
		self.personajes()
		self.colisiones()
		self.onTick()
		
		keyboard.up().onPressDo { if (naveInicial.puedeMoverArriba()) naveInicial.subir()}
		keyboard.down().onPressDo { if (naveInicial.puedeMoverAbajo()) naveInicial.bajar()}
		keyboard.left().onPressDo { if (naveInicial.puedeMoverIzquierda()) naveInicial.izquierda()}
		keyboard.right().onPressDo { if(naveInicial.puedeMoverDerecha()) naveInicial.derecha()}		
		keyboard.space().onPressDo({naveInicial.disparar()})
		
	}
	
	method visuales()
	
	method personajes(){		
		self.visuales().forEach({x => game.addVisual(x)})
	}
	
	method colisiones(){
		game.onCollideDo(naveInicial,{algo=>algo.teChoco(naveInicial)})
	}
	
	method pasarASiguientePantalla(){
		audioNivel.pause()
		game.clear()
		pantallaNivel.configurar()
	}
	
	method perder(){
		game.clear()
		audioNivel.pause()
		perdisteAudio.play()
		pantallaPerdiste.configurar()
	}
	
	method onTick() {}
}