import { Controller } from "@hotwired/stimulus";
import debounce from "lodash.debounce";

// Connects to data-controller="poster"
export default class extends Controller {
  connect() {
    // Send form data to the posts controller, autosave action.
    // The action will save the post as a PostDraft.
    this.form = this.element.closest("form");
    this.formData = new FormData(this.form);

    // Set url to point to post '/posts/:id/autosave', to: 'posts#autosave', as: 'autosave_post'
    this.url = this.form.action + "/autosave";
    // Get the autosave delay from the data-autosave-delay attribute on the form.
    const autosave_delay = this.form.dataset.autosaveDelay;
    this.autosaveDelayAsInt = parseInt(autosave_delay);

    const requestToDelay = () => this.sendRequest(this.url, this.formData);

    // Debounce the request to avoid sending too many requests.
    // The request will be sent after the time specified in autosave_target
    // has passed since the last call to the debounced function.

    this.debouncedRequest = debounce(requestToDelay, this.autosaveDelayAsInt);
  }

  save() {
    this.formData = new FormData(this.form);

    // Call the debounced request with the new form data.
    this.debouncedRequest(this.url, this.formData);
  }

  sendRequest(url, formData) {
    console.log("Sending request to " + url);
    // fetch and trigger turbo_stream response

    fetch(url, {
      method: "POST",
      body: formData,
      headers: {
        "X-CSRF-Token": document.querySelector("meta[name='csrf-token']")
          .content,
        Accept: "text/vnd.turbo-stream.html",
      },
      credentials: "same-origin",
    }).then((response) => {
      response.text().then((html) => {
        document.body.insertAdjacentHTML("beforeend", html);
      });
    });
  }
}
