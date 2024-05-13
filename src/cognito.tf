resource "aws_cognito_user_pool" "fast_food_user_pool" {
  name = "${var.projectName}"
  username_attributes = [] # Apenas CPF como atributo de nome de usuário  
  auto_verified_attributes = []
  mfa_configuration        = "OFF"

  # Configuração de políticas para forçar verificação de CPF e não exigir senha
  password_policy {
    minimum_length    = 6
    require_lowercase = false
    require_numbers   = false
    require_symbols   = false
    require_uppercase = false
  }

  schema {
    attribute_data_type = "String"
    mutable             = true # Tornar imutável
    name                = "cpf"
    required            = false
    string_attribute_constraints {
      min_length = 11
      max_length = 11
    }
  }
}

resource "aws_cognito_user_pool_client" "fast_food_client" {
  name = "fast_food_client"
  user_pool_id = aws_cognito_user_pool.fast_food_user_pool.id

  # Configuração para gerar um segredo de cliente
  generate_secret = true

  # Configurações opcionais
  allowed_oauth_flows_user_pool_client = true
  allowed_oauth_flows = ["code"]
  allowed_oauth_scopes = ["email", "openid", "profile"]
  callback_urls = ["https://example.com/callback"]
  logout_urls = ["https://example.com/logout"]
  supported_identity_providers = ["COGNITO"]

  # Configuração para desativar a verificação e confirmação assistida
  #prevent_user_existence_errors = "ENABLED"
  #explicit_auth_flows = ["ADMIN_NO_SRP_AUTH", "USER_PASSWORD_AUTH"]
}

output "user_pool_client_id" {
  value = aws_cognito_user_pool_client.fast_food_client.id
}

output "user_pool_id" {
  value = aws_cognito_user_pool.fast_food_user_pool.id
}