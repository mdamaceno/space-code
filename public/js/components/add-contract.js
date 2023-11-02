import {LitElement, html, until} from 'https://cdn.jsdelivr.net/gh/lit/dist@3/all/lit-all.min.js';

class AddContract extends LitElement {
  static properties = {
    errors: { type: Array },
  }

  _payloadInput(resource) {
    return html`
      <label for=${`contract-payload-${resource}`}>${resource} (weight)</label>
      <input type="number" id=${`contract-payload-${resource}`} name=${`contract[payload][${resource}]`} value="0">
     `;
  }

  async _fetchPlanets() {
    return fetch('/api/planets').then(response => {
      if (response.ok) {
        return response.json();
      }

      throw new Error('Network response was not ok.');
    }).then(data => {
      return data.planets;
    }).catch(error => {
      console.error('There has been a problem with your fetch operation:', error);
    });
  }

  _planetsSelect(planets, type) {
    return html`
      <label for=${`contract-${type}`}>${type}</label>
      <select id=${`contract-${type}`} name=${`contract[${type}]`} required>
        ${planets.map(planet => html`
          <option value=${planet.id}>${planet.name}</option>
        `)}
      </select>
    `;
  }

  _checkStatus(response) {
    if (response.status >= 200 && response.status < 300) {
      return Promise.resolve(response);
    }

    return Promise.reject(response);
  }

  submitForm(event) {
    event.preventDefault();
    const form = event.target;
    const payload = ['water', 'food', 'minerals'].map(resource => {
      const weight = parseInt(form.elements[`contract[payload][${resource}]`].value);

      if (weight < 1 || isNaN(weight)) return;

      return {
        name: resource,
        weight,
      };
    }).filter(Boolean);

    const contract = {
      description: form.elements['contract[description]'].value,
      value: form.elements['contract[value]'].value,
      origin_planet_id: form.elements['contract[origin]'].value,
      destination_planet_id: form.elements['contract[destination]'].value,
      payload,
    };

    fetch('/api/contracts', {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json'
      },
      body: JSON.stringify({ contract })
    }).then(this._checkStatus).then(response => {
      if (response.ok) {
        this.errors = [];
        return response.json();
      }

      throw new Error('Network response was not ok.');
    }).then(data => {
      console.log(data);
      alert('Contract created successfully!');
    }).catch(error => {
      console.error('There has been a problem with your fetch operation');
      return error.json();
    }).then(data => {
      this.errors = data;
      console.log(this.errors);
    });
  }

  render() {
    return html`
      <h2>Add Contract</h2>

      ${this.errors ? html`
        <ul>
          ${Object.keys(this.errors).map(key => this.errors[key].map(error => html`
            <li>${key} ${error}</li>
          `))}
        </ul>
      ` : ''}

      <form @submit=${this.submitForm}>
        <label for="contract-description">Description</label>
        <input type="text" id="contract-description" name="contract[description]" required>
        <br><br>

        <label for="contract-value">Value</label>
        <input type="number" id="contract-value" name="contract[value]" required>
        <br><br>

        ${until(this._fetchPlanets().then(planets =>
          html`
            ${this._planetsSelect(planets, 'origin')}
            <br><br>

            ${this._planetsSelect(planets, 'destination')}
            <br><br>
          `
        ), 'Loading...')}

        ${this._payloadInput('water')}
        <br><br>

        ${this._payloadInput('food')}
        <br><br>

        ${this._payloadInput('minerals')}
        <br><br>

        <button type="submit">Add contract</button>
      </form>
    `;
  }
}

customElements.define('add-contract', AddContract);
