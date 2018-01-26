(function (next) {

    console.log('isWebworker?', typeof WorkerGlobalScope !== 'undefined' && self instanceof WorkerGlobalScope)

    importScripts("worker.js");
    next.call(null, self, self.console, Elm);

})(function (window, console, Elm) {
    console.log("[worker-init] worker imported, setting it up...");

    const worker = Elm.Worker.worker({
    });

    worker.ports.fromWorker.subscribe(message => {
        console.log('worker.postMessage', message);
        window.postMessage(message);
    });

    window.addEventListener('message', ev => {
        console.log('worker.onmessage', ev);
        const message = ev.data;
        worker.ports.toWorker.send(message);
    });

    console.log("[worker-init] worker ready.");

    setTimeout(() => {
        console.log("[worker-init] -> feeding the worker...");
        worker.ports.toWorker.send({ type: "WORKER_SETUP_COMPLETED" });
        console.log("[worker-init] -> worker fed.");
    }, 1000);

});
