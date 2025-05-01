// main.js

document.addEventListener('DOMContentLoaded', function() {
    const button = document.querySelector('.button');
  
    button.addEventListener('click', function() {
      // Generar un color aleatorio en formato hexadecimal
      const randomColor = '#' + Math.floor(Math.random()*16777215).toString(16);
  
      // Aplicar el color aleatorio al fondo del botón
      button.style.backgroundColor = randomColor;
    });
  });
  
  // main.js

// Esperar a que el DOM esté completamente cargado
document.addEventListener("DOMContentLoaded", function () {
  // Obtener el formulario por su ID
  const formulario = document.getElementById("miFormulario");

  // Agregar un evento de envío al formulario
  formulario.addEventListener("submit", function (event) {
      // Evitar que el formulario se envíe normalmente
      event.preventDefault();

      // Mostrar un mensaje en la consola
      console.log("Formulario enviado!");

      // Puedes agregar más lógica aquí, como enviar datos al servidor
  });
});
