import wollok.game.*
import nivel1.*
import nivel2.*
import nivel3.*
import logicaNiveles.*
import juego.*

object inicio{

	method config() {
	    
		//titulo y limites del juego
		game.title("Invasion alienigena")
		game.height(15)
		game.width(25)
		game.clear()
		pantallaInicial.configurar()
	}
}

class Pantalla {
	var property position = game.at(0,0)
	const audioEnter = "controlesYnivel.mp3"
	method image() = null
}

class PantallaNivel inherits Pantalla {
	var nivelActual

	method configurar() {
			game.addVisual(self)
			game.sound(audioEnter).play()
			keyboard.enter().onPressDo{self.pasarAlNivel()}

	}
	method pasarAlNivel() {
		game.sound(audioEnter).play()
		nivelActual.config()//podemos poner el nivel en el que querramos empezar
	}
}

class PantallaNoNivel inherits Pantalla {
	var pantallaSiguiente
	
	method configurar() {
		if (pantallaSiguiente != null) {
			game.addVisual(self)
			game.sound(audioEnter).play()
			keyboard.enter().onPressDo{self.pasarASiguientePantalla()}	
		} else {
			game.addVisual(self)
			keyboard.q().onPressDo {game.stop()}
		}

	}
	method pasarASiguientePantalla() {
			game.clear()
			pantallaSiguiente.configurar()
	}
}

object pantallaInicial inherits PantallaNoNivel(audioEnter = "empezar.mp3", pantallaSiguiente = pantallaControles) {	
	override method image()= "inicio1.png"
	
	override method configurar() {
			game.addVisual(self)
			keyboard.enter().onPressDo{self.pasarASiguientePantalla()}
	}
}

object pantallaControles inherits PantallaNoNivel(audioEnter = "empezar.mp3", pantallaSiguiente = pantallaNivel1) {
	override method image()= "controles.png"
}

object pantallaNivel1 inherits PantallaNivel(nivelActual = nivel1) {
	override method image()= "instr1.png"
	
}

object pantallaNivel2 inherits PantallaNivel(nivelActual = nivel2) {
	override method image()= "instr2.png"
	
}

object pantallaNivel3 inherits PantallaNivel(nivelActual = nivel3) {
	override method image()= "instr3.png"
	
}

object pantallaPerdiste inherits PantallaNoNivel(pantallaSiguiente = null) {
	override method image()= "perdiste.png"
}

object pantallaGanaste  inherits PantallaNoNivel(pantallaSiguiente = null) {
	override method image()= "ganaste.png"	
}