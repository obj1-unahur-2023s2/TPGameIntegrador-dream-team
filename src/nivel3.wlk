import wollok.game.*
import juego.*
import consola.*
import nivel1.*
import nivel2.*
import logicaNiveles.*
import juego.*
object nivel3 inherits LogicaNivel (audioNivel = game.sound("nivel3.mp3")){
	const fondoNivel3 = new Fondo (image="fondo3.png")
	const property corazado1 = new Corozado()
	const property vidaNaveEnemiga1 = new VidasEnemigos5(naveEspacial = corazado1,position = game.at(4,8))
	const property vidaAcorazador = new VidasNivel3(numero = 2,position = game.at(0,8))
	const property vidaHalcon444 = new VidasNivel3(numero=1,position = game.at(0,9))
	
	override method visuales() = [fondoNivel3,corazado1,naveInicialNivel3,contadorBalasNivel3,cantidadBalasNivel3,vidaNaveEnemiga1,vidaHalcon444,vidaAcorazador,vidasNivel3]
	 
	
	override method config(){	
		
		game.clear()
	    audioNivel.shouldLoop(true)
	    keyboard.w().onPressDo({audioNivel.volume(1)})
		keyboard.s().onPressDo({audioNivel.volume(0.5)})
		keyboard.q().onPressDo({audioNivel.volume(0)})
	    game.schedule(500, {audioNivel.play()})
			
		self.personajes()
		self.onTick()

		keyboard.left().onPressDo { if (naveInicialNivel3.puedeMoverIzquierda()) naveInicialNivel3.izquierda()}
		keyboard.right().onPressDo { if(naveInicialNivel3.puedeMoverDerecha()) naveInicialNivel3.derecha()}
		keyboard.space().onPressDo({naveInicialNivel3.disparar()})	
	}
	
	
	override method colisiones() {}
	
	override method onTick(){
		game.onTick(1,"actualizar contador balas",{cantidadBalasNivel3.actualizar()})
		game.onTick(1,"actualizar cantidad vidas corazado1",{corazado1.actualizar()})
		game.onTick(1,"actualizar cantidad vidas halcon 444",{naveInicialNivel3.actualizar()})
		game.onTick(800, "movimientoNaveEnemiga", {corazado1.seguirNave()})		
		game.onTick(1000, "disparoNaveEnemiga", {corazado1.disparar()})		
	}
	
	method pasarASiguientePantalla() {
		const ganaste = game.sound("ganaste.mp3")
		game.clear()
		audioNivel.pause()
		ganaste.play()
		pantallaGanaste.configurar()
	}
	
	method perder() {
		game.clear()
		audioNivel.pause()
		perdisteAudio.play()
		pantallaPerdiste.configurar()
	}
}

object balas{
	var property image = "balas.png"
	var property position = posAleatoria.posicionAleatoria(1)
}

object cantidadBalasNivel3{
	var property position = game.at(3,7)	
	var property textColor= "#FFFFFF"
	var text = naveInicialNivel3.balas()
	
	method actualizar(){
		text = naveInicialNivel3.balas()
	}
	
	method text() = text.toString()
}

class Corozado{
	var property vida = 4
	var property image = "naveEnemigaNivel3.png"
	var property position = game.at(0.randomUpTo(game.width()-1).truncate(0),13)
	var property contadorVidas = self.vida()
	
	method recibirDisparo(cantidad){
		if (vida >= 1){
		 vida -= cantidad
		}
		else{
			self.image("explosion.png")
			game.schedule(100,{game.removeVisual(self)})
			nivel3.pasarASiguientePantalla()
		}}
	method actualizar(){
		contadorVidas = self.vida()
	}
	method disparar(){
	const disparo = new DisparosNivel3Enemiga(position = self.position())
	if (vida > 0){
		disparo.agregarDisparo()
	}
	
	}
	method seguirNave(){
	const otroPosicion2 = naveInicialNivel3.position()
	const newX2 = position.x() + if (otroPosicion2.x() > position.x()) 1 else -1
		position = game.at(newX2, 13)
	}	
}

object naveInicialNivel3{
	var property image = "naveMejoradaNivel3.png"
	var property position = game.at(0.randomUpTo(game.width()-1).truncate(0),0)	
	var property vida = 3
	var property balas = 50	
	var property contadorVidas = self.vida()
	
	method izquierda() {position = position.left(1)}		
	method derecha() {position = position.right(1)}
	
	method disparar(){
	const disparo = new DisparosNivel3(position = self.position())
		if (balas > 0){
			disparo.agregarDisparo()
			balas -= 1
		}
	}
	method puedeMoverDerecha() = self.position().x() < 23
	method puedeMoverIzquierda() = self.position().x() > 0
	
	method actualizar(){
		contadorVidas = self.vida()
	}
	
	method recibirDisparo(cantidad){
		if (vida >= 1){
		 vida -= cantidad
		}
		else{
			self.image("explosion.png")
			game.removeVisual(self)
			nivel3.perder()
		}}
	
}
object contadorBalasNivel3{
	var property position = game.at(0,7)
	var property image = "contadorBalas.png" 
}	
class DisparosNivel3 inherits Disparos{
	
	override method image() = "disparoArriba.png"
	
	override method moverRight(objeto,number){
		objeto.position(objeto.position().up(number))
		if (self.position() == nivel3.corazado1().position()){
            nivel3.corazado1().recibirDisparo(1)
            if (nivel3.corazado1().vida() > 0) {
            game.removeTickEvent("mover disparo")
            game.removeVisual(self)
            }
		}
	}
}
class DisparosNivel3Enemiga	 inherits Disparos{
	
	override method image() = "disparoNaveEnemiga.png"
	
	override method moverRight(objeto,number){
		objeto.position(objeto.position().down(number))
		if (self.position() == naveInicialNivel3.position()){
            naveInicialNivel3.recibirDisparo(1)
            game.removeTickEvent("mover disparo")
            game.removeVisual(self)
			}
	}
}