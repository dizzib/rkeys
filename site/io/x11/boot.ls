module.exports = (cb) ->
  err <- require \./helper .init!
  return cb err if err
  err <- require \./keycode .init!
  return cb err if err
  err <- require \./active-window .init!
  cb err
