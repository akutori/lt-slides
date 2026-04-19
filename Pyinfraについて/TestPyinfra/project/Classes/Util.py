from pyinfra.operations import files

class Util:
    
    @staticmethod
    def run_in(path:str, command:str) -> str:
        return f"cd {path} && {command}"
    
    @staticmethod
    def chown_directories(task_name:str,user:str,group:str,paths:list[str]):
        
        if not paths:
            raise ValueError("pathsリストが空です。少なくとも1つのパスを指定してください。")
        
        
        for path in paths:
        
            files.directory(
                name=task_name,
                path=path,
                user=user,
                group=group,
                recursive=True,
                _sudo=True,
            )