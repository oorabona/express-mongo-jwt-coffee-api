module.exports = (base_path) ->
  {
    pubKey: "#{base_path}/jwt-key.pub"
    pemKey: "#{base_path}/jwt-key.pem"
    priKey: "#{base_path}/secret.key"
  }
