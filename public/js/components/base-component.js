import {LitElement, html} from 'https://cdn.jsdelivr.net/gh/lit/dist@3/all/lit-all.min.js';

class BaseComponent extends LitElement {
  static properties = {
    errors: { type: Array },
  }

  _checkStatus(response) {
    if (response.status >= 200 && response.status < 300) {
      return Promise.resolve(response);
    }

    return Promise.reject(response);
  }

  _errorsTemplate(errors) {
    return errors ? html`
      <ul>
        ${Object.keys(errors).map(key => errors[key].map(error => html`
          <li>${key} ${error}</li>
        `))}
      </ul>
    ` : '';
  }
}

export default BaseComponent;
