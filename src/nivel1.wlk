import wollok.game.*
import consola.*
import juego.*
import nivel2.*
import nivel3.*
import logicaNiveles.*
import juego.*
object nivel1 inherits LogicaNivel (audioNivel = game.sound("nivel1.mp3"),pantallaNivel=pantallaNivel2) {
	const property fondo1 = new Fondo (image= "fondo1.png")
	const cargarBalas1 = new Balas()
	const cargarBalas2 = new Balas()
	const property naveEnemiga1 = new AienEnemigo(image = "alienEnemigo.png") 
	const property naveEnemiga2 = new AienEnemigo(image = "alienenemigo2.png")
	const property naveEnemiga3 = new AienEnemigo(image = "alienenemigo3.png")
	const property tanquesLista = [tanqueNafta1, tanqueNafta2]
	const property balasLista = [cargarBalas1, cargarBalas2]
	const property enemigosLista = [naveEnemiga1, naveEnemiga2, naveEnemiga3]
	
	override method visuales() = [fondo1, naveInicial, vidas, contadorNafta,cantidadNafta,contadorBalas,cantidadBalas, naveEnemiga1,naveEnemiga2,naveEnemiga3,tanqueNafta1,tanqueNafta2,cargarBalas1,cargarBalas2]

	override method colisiones(){
		game.onCollideDo(naveInicial,{algo=>algo.teChoco(naveInicial)})
	}
	
	override method onTick(){
		game.onTick(1000.randomUpTo(2000).truncate(0), "movimientoNaveEnemiga", {naveEnemiga1.acercarseANave()})
		game.onTick(1000.randomUpTo(2000).truncate(0), "movimientoNaveEnemiga", {naveEnemiga2.acercarseANave()})
		game.onTick(1000.randomUpTo(2000).truncate(0), "movimientoNaveEnemiga", {naveEnemiga3.acercarseANave()})
		
		game.onTick(1,"actualizar contador nafta",{cantidadNafta.actualizar()})
		game.onTick(1,"actualizar contador balas",{cantidadBalas.actualizar()})
		game.onTick(1,"pasar de nivel",{self.pasarASiguientePantalla()})
		game.onTick(1,"actualizar cantidad vidas enemigo1",{naveEnemiga1.actualizar()})
		game.onTick(1,"actualizar cantidad vidas enemigo2",{naveEnemiga2.actualizar()})
		game.onTick(1,"actualizar cantidad vidas enemigo3",{naveEnemiga3.actualizar()})
		
		
	}
		
	override method pasarASiguientePantalla() {
		if (self.enemigosLista() == []) {
			super()
		}
	}
}