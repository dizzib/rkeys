Cp = require \child_process
Sh = require \shelljs/global

# http://stackoverflow.com/questions/10175812/how-to-create-a-self-signed-certificate-with-openssl?rq=1

const LIFE = 30000days

module.exports = step1

function check-exit code, signal, step, cb
  return log "Error! Step #step exited with code=#code" unless code is 0
  return log "Error! Step #step exited with signal=#signal" if signal
  cb!

function step1
  const ARGS-STEP1 = <[ req -x509 -newkey rsa:2048 -keyout key.pem -out cert.pem -nodes -days ]> ++ [ LIFE ]
  cp = Cp.spawn \openssl, ARGS-STEP1, stdio:\inherit
  cp.on \exit, (code, signal) -> check-exit code, signal, 1, step2

function step2
  const ARGS-STEP2 = <[ x509 -inform PEM -outform DM -in cert.pem -out cert.crt ]>
  cp = Cp.spawn \openssl, ARGS-STEP2, stdio:\inherit
  cp.on \exit, (code, signal) -> check-exit code, signal, 2, verify

function verify
  return if test \-e, \cert.crt
  log 'Error! Certificate file cert.crt was not generated'
