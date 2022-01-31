diagnosis = [
  {
      "code": "1",
      "description": "Cholera due to Vibrio cholerae 01, biovar cholerae",
      "category_id": 1,
      "full_code": "M001"
  },
  {
      "code": "2",
      "description": "Typhoid meningitis",
      "category_id": 2,
      "full_code": "L0101",
  },
  {
      "code": "3",
      "description": "Paratyphoid fever A",
      "category_id": 3,
      "full_code": "P011"
  }
]

diagnosis.each do |d|
  Diagnosis.create(d)
end