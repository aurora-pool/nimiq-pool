const fs = require('fs');
const https = require('https');
const btoa = require('btoa');
const Nimiq = require('@nimiq/core');

class MetricsServer {
    constructor(sslKeyPath, sslCertPath, port, password) {

        const options = {
            key: fs.readFileSync(sslKeyPath),
            cert: fs.readFileSync(sslCertPath)
        };

        https.createServer(options, (req, res) => {
            if (req.url !== '/metrics') {
                res.writeHead(301, {'Location': '/metrics'});
                res.end();
            } else if (password && req.headers.authorization !== `Basic ${btoa(`metrics:${password}`)}`) {
                res.writeHead(401, {'WWW-Authenticate': 'Basic realm="Use username metrics and user-defined password to access metrics." charset="UTF-8"'});
                res.end();
            } else {
                var clientCounts = this._poolServer.getClientModeCounts();
                var totalClientCounts = clientCounts.unregistered + clientCounts.smart + clientCounts.nano

                var json = JSON.stringify({
                  name: this._poolServer.name,
                  poolAddress: this._poolServer._config.address,
                  averageHashrate: this._poolServer.averageHashrate,
                  totalClientCounts: totalClientCounts,
                  clientCounts: clientCounts,
                  poolFee: this._poolServer._config.poolFee,
                  numBlocksMined: this._poolServer.numBlocksMined,
                  numIpsBanned: this._poolServer.numIpsBanned,
                  totalShareDifficulty: this._poolServer.totalShareDifficulty,
                  payoutConfirmations: this._poolServer._config.payoutConfirmations,
                  autoPayOutLimit: Nimiq.Policy.satoshisToCoins(this._poolServer._config.autoPayOutLimit),
                });

                res.writeHead(200, {"Content-Type": "application/json"});
                res.end(json);
            }
        }).listen(port);

        /** @type {Map.<string, {occurrences: number, timeSpentProcessing: number}>} */
        this._messageMeasures = new Map();
    }

    /**
     * @param {PoolServer} poolServer
     */
    init(poolServer) {
        /** @type {PoolServer} */
        this._poolServer = poolServer;
    }
}

module.exports = exports = MetricsServer;
