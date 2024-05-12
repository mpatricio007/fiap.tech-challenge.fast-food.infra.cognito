provider "aws" {
  region = "us-east-1" 
}

resource "aws_cognito_user_pool" "example" {
  name = "example-user-pool"
  username_attributes = ["cpf"] # Apenas CPF como atributo de nome de usuário
  auto_verified_attributes = ["cpf"] # Apenas CPF como atributo verificado automaticamente

  # Configuração de políticas para forçar verificação de CPF e não exigir senha
  password_policy {
    minimum_length    = 0
    require_lowercase = false
    require_numbers   = false
    require_symbols   = false
    require_uppercase = false
  }

  schema {
    attribute_data_type = "String"
    mutable             = false # Tornar imutável
    name                = "cpf"
    required            = true
    string_attribute_constraints {
      min_length = 11
      max_length = 11
    }
  }
}

output "user_pool_id" {
  value = aws_cognito_user_pool.example.id
}