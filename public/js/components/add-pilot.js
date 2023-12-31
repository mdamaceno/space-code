import {html} from 'https://cdn.jsdelivr.net/gh/lit/dist@3/core/lit-core.min.js';
import BaseComponent from './base-component.js';

class AddPilot extends BaseComponent {
  submitForm(event) {
    event.preventDefault();
    const form = event.target;
    const pilot = {
      name: form.elements['pilot[name]'].value,
      age: form.elements['pilot[age]'].value,
      ship: {
        name: form.elements['pilot[ship][name]'].value,
        fuel_capacity: form.elements['pilot[ship][fuel_capacity]'].value,
        fuel_level: form.elements['pilot[ship][fuel_level]'].value,
        weight_capacity: form.elements['pilot[ship][weight_capacity]'].value,
      }
    };

    fetch('/api/pilots', {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json'
      },
      body: JSON.stringify({ pilot })
    }).then(this._checkStatus).then(response => {
      if (response.ok) {
        this.errors = [];
        return response.json();
      }

      throw new Error('Network response was not ok.');
    }).then(data => {
      alert(`Pilot ${data.pilot.name} added with id ${data.pilot.id}`);
      console.log('Pilot created', data.pilot);
      form.reset();
      form.elements['pilot[name]'].focus();
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
      <h2>Add Pilot</h2>

      ${this._errorsTemplate(this.errors)}

      <form @submit=${this.submitForm}>
        <label for="pilot-name">Name</label>
        <input type="text" id="pilot-name" name="pilot[name]" required>
        <br><br>

        <label for="pilot-age">Age</label>
        <input type="number" id="pilot-age" name="pilot[age]" min="18" value="18" required>
        <br><br>

        <label for="pilot-ship-name">Ship Name</label>
        <input type="text" id="pilot-ship-name" name="pilot[ship][name]" required>
        <br><br>

        <label for="pilot-ship-fuel_capacity">Fuel Capacity</label>
        <input type="number" id="pilot-ship-fuel_capacity" name="pilot[ship][fuel_capacity]" min="0" value="0" required>
        <br><br>

        <label for="pilot-ship-fuel_level">Fuel Level</label>
        <input type="number" id="pilot-ship-fuel_level" name="pilot[ship][fuel_level]" min="0" min="0" value="0" required>
        <br><br>

        <label for="pilot-ship-weight_capacity">Weight Capacity</label>
        <input type="number" id="pilot-ship-weight_capacity" name="pilot[ship][weight_capacity]" min="0" value="0" required>
        <br><br>

        <button type="submit">Add Pilot</button>
      </form>
    `;
  }
}

customElements.define('add-pilot', AddPilot);
