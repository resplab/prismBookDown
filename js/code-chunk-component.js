customElements.define('code-chunk', class extends HTMLElement {
      constructor() {
        super()
        this.attachShadow( { mode: 'open' } )
            .innerHTML = `
                    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.3.1/css/bootstrap.min.css" integrity="sha384-ggOyR0iXCbMQv3Xipma34MD+dH/1fQ784/j6cY/iJTQUOhcWr7x9JvoRxT2MZw1T" crossorigin="anonymous">
    <link rel="stylesheet" href="shadow.css" type="text/css">
                <slot name="language"></slot>
                <slot name="code"></slot>
                `
    }
      connectedCallback() {
        this.innerHTML = `<div slot="language">        
                <div class="code-chunk">
                <div class="row">
  <div class="col-sm-11 no-gutters code-lang-col">
  <div class="btn-group float-right">
  <button type="button" class="btn btn-primary dropdown-toggle code-lang" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
    Language
  </button>
  <div class="dropdown-menu">
    <a class="dropdown-item" value = "mac" href="#mac">Shell (MAC)</a>
    <a class="dropdown-item" value = "linux" href="#linux">Shell (Linux)</a>
    <a class="dropdown-item" value = "windows" href="#windows">Shell (Windows)</a>
    <a class="dropdown-item" value = "js" href="#js">Javascript</a>
    <a class="dropdown-item" value = "r" href="#r">R</a>
    <a class="dropdown-item" value = "python" href="#python">Python</a>
  </div>
  </div>
  </div>
  <div class="col-sm-1 no-gutters copy-col">
  <a href="#" class="btn btn-primary active copy-button float-left js-copy" role="button" aria-pressed="true">Copy</a>
  
  </div></div></div>
            </div>`
      }
});
