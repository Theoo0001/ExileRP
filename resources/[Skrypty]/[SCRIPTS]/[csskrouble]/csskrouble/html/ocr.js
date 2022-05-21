$(document).ready(function () {
  window.addEventListener('message', (event) => {
    if (event.data.type === 'ocr') {
      Tesseract.recognize(event.data.ss, 'eng').then(({ data: { text } }) => {
        $.post('https://csskrouble/ocr', JSON.stringify({ text }));
      });
    }
  });
});
