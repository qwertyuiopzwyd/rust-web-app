use proc_macro::TokenStream;

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn it_works() {
        let result = add(2, 2);
        assert_eq!(result, 4);
    }
}

#[proc_macro]
pub fn di(input: TokenStream) -> TokenStream {
    let input_str = input.to_string();
    let dimp = match input_str.as_str() {
        "\"AL\"" => {
            r#"
            use std::fs::ReadDir;
            pub type CLn = ReadDir;
            "#
        },
        "\"BL\"" => {
            r#"
            use std::process::Stdio;
            pub type CLn = Stdio;
            "#
        },
        "\"CL\"" => {
            r#"
            use std::process::Command;
            pub type CLn = Command;
            "#
        },
        "\"DL\"" => {
            r#"
            use std::fs::File;
            pub type CLn = File;
            "#
        },
        "\"EL\"" => {
            r#"
            use std::process::ExitStatus;
            pub type CLn = ExitStatus;
            "#
        },
        _ => "pub type CLn = ();"
    };
    
    dimp.parse().unwrap()
}